import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import 'package:provider/provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/brand_button.dart';
import '../../widgets/peripheral_scene.dart';
import '../../services/component_data_service.dart';
import '../../models/app_models.dart';
import '../../providers/build_provider.dart';
import '../../providers/cart_provider.dart';
import '../main/main_screen.dart';

class BuilderScreen extends StatefulWidget {
  const BuilderScreen({super.key});

  @override
  State<BuilderScreen> createState() => _BuilderScreenState();
}

class _BuilderScreenState extends State<BuilderScreen> {
  bool _previewOpen = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ComponentCategory.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PC Builder', style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600)),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: BBTextResponsive.labelMedium(context, weight: FontWeight.w600),
            unselectedLabelStyle: BBTextResponsive.labelMedium(context),
            tabs: ComponentCategory.values.map((cat) => Tab(
              icon: Icon(cat.icon, size: 20),
              text: cat.label,
            )).toList(),
          ),
        ),
        body: Consumer<BuildProvider>(
          builder: (context, buildProvider, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Keep the live preview when there is room; on very short
                // windows it collapses so the component list never overflows.
                final showPreview =
                    _previewOpen && constraints.maxHeight >= 300;
                final previewHeight =
                    (constraints.maxHeight * 0.33).clamp(112.0, 260.0);

                return Column(
                  children: [
                    _BuildSummaryCard(
                      buildProvider: buildProvider,
                      showPreview: showPreview,
                      previewHeight: previewHeight,
                      onTogglePreview: constraints.maxHeight >= 300
                          ? () => setState(
                                () => _previewOpen = !_previewOpen,
                              )
                          : null,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: ComponentCategory.values.map((category) {
                          final components =
                              ComponentDataService.getByCategory(category);
                          final selected =
                              buildProvider.getSelectedComponent(category);
                          return _ComponentList(
                            category: category,
                            components: components,
                            selectedComponent: selected,
                            selectedOption: selected?.options
                                    .where((o) => o.isDefault)
                                    .firstOrNull ??
                                selected?.options.firstOrNull,
                            onSelect: (component, option) {
                              buildProvider.selectComponent(
                                category,
                                component,
                                option: option,
                              );
                              _goToNextStep(context, buildProvider);
                            },
                            onClear: () {
                              buildProvider.clearComponent(category);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    _BuildActionBar(buildProvider: buildProvider),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Moves to the next category that still has nothing picked (wrapping around).
  static void _goToNextStep(BuildContext context, BuildProvider buildProvider) {
    final tabs = DefaultTabController.of(context);
    const steps = ComponentCategory.values;
    for (var offset = 1; offset < steps.length; offset++) {
      final next = (tabs.index + offset) % steps.length;
      if (buildProvider.getSelectedComponent(steps[next]) == null) {
        tabs.animateTo(next);
        return;
      }
    }
  }
}

class _BuildSummaryCard extends StatelessWidget {
  final BuildProvider buildProvider;
  final bool showPreview;
  final double previewHeight;
  final VoidCallback? onTogglePreview;

  const _BuildSummaryCard({
    required this.buildProvider,
    required this.showPreview,
    required this.previewHeight,
    this.onTogglePreview,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final build = buildProvider.currentBuild;
    final completed = build?.componentCount ?? 0;
    final total = ComponentCategory.values.length;
    final complete = build?.isComplete ?? false;

    return Container(
      margin: const EdgeInsets.fromLTRB(BBColors.padM, BBColors.padM, BBColors.padM, BBColors.padS),
      padding: const EdgeInsets.all(BBColors.padM),
      decoration: BoxDecoration(
        color: isDark ? BBColors.nightSurfaceAlt : BBColors.daySurface,
        borderRadius: BorderRadius.circular(BBColors.radiusLg),
        border: Border.all(color: isDark ? BBColors.nightDivider : BBColors.dayDivider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      build?.name ?? 'Your build',
                      style: BBTextResponsive.titleMedium(context, weight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      complete ? 'All $total parts picked' : '$completed of $total parts · ${total - completed} to go',
                      style: BBTextResponsive.bodySmall(
                        context,
                        color: complete ? BBColors.accentGreen : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: BBColors.padS),
              Flexible(
                child: Text(
                  context.money(build?.totalPrice ?? 0),
                  style: BBTextResponsive.titleLarge(context, weight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onTogglePreview != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onTogglePreview,
                  tooltip: showPreview ? 'Hide 3D preview' : 'Show 3D preview',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    showPreview
                        ? Icons.view_in_ar_rounded
                        : Icons.view_in_ar_outlined,
                    size: 20,
                    color: showPreview
                        ? BBColors.readable(context, BBColors.accentBlue)
                        : BBColors.textMuted(context),
                  ),
                ),
              ],
            ],
          ),
          if (showPreview) ...[
            const SizedBox(height: BBColors.padS),
            PeripheralScene(
              slots: SceneSlot.fromBuild(build),
              height: previewHeight,
              showControls: true,
              showLegend: previewHeight >= 170,
            ),
          ],
          const SizedBox(height: BBColors.padM),
          ClipRRect(
            borderRadius: BorderRadius.circular(BBColors.radiusSm),
            child: LinearProgressIndicator(
              value: completed / total,
              minHeight: 6,
              color: complete ? BBColors.accentGreen : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentList extends StatelessWidget {
  final ComponentCategory category;
  final List<Component> components;
  final Component? selectedComponent;
  final ComponentOption? selectedOption;
  final void Function(Component, ComponentOption) onSelect;
  final VoidCallback onClear;

  const _ComponentList({
    required this.category,
    required this.components,
    required this.selectedComponent,
    required this.selectedOption,
    required this.onSelect,
    required this.onClear,
  });

  @override
    Widget build(BuildContext context) {

      if (components.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 64, color: BBColors.textMuted(context)),
            const SizedBox(height: BBColors.padM),
            Text(
              'No ${category.label.toLowerCase()} available',
              style: BBTextResponsive.bodyLarge(context, color: BBColors.textMuted(context)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(BBColors.padL, BBColors.padM, BBColors.padL, BBColors.padXXL),
      itemCount: components.length,
      separatorBuilder: (_, _) => const SizedBox(height: BBColors.padM),
      itemBuilder: (context, index) {
        final component = components[index];
        final isSelected = selectedComponent?.id == component.id;
        final option = isSelected ? (selectedOption ?? component.options.firstOrNull) : component.options.firstOrNull;

        return _ComponentCard(
          component: component,
          selectedOption: option,
          isSelected: isSelected,
          categoryColor: category.color,
          onTap: () => _showOptionSheet(context, component),
          onClear: isSelected ? onClear : null,
        );
      },
    );
  }

  void _showOptionSheet(BuildContext context, Component component) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ComponentOptionSheet(
        component: component,
        selectedOption: selectedOption,
        onSelect: (option) => onSelect(component, option),
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final Component component;
  final ComponentOption? selectedOption;
  final bool isSelected;
  final Color categoryColor;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _ComponentCard({
    required this.component,
    required this.selectedOption,
    required this.isSelected,
    required this.categoryColor,
    required this.onTap,
    this.onClear,
  });

  @override
    Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return GestureDetector(
      onTap: onTap,
      child: BrandCard(
        variant: isSelected ? BrandCardVariant.gradient : BrandCardVariant.defaultCard,
        gradient: isSelected
            ? LinearGradient(colors: [categoryColor.withValues(alpha: 0.12), categoryColor.withValues(alpha: 0.04)])
            : null,
        border: isSelected ? Border.all(color: BBColors.accent(context), width: 2) : null,
        padding: const EdgeInsets.all(BBColors.padM),
        child: Row(
          children: [
            // Image
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
                child: (selectedOption?.image ?? component.images.firstOrNull) != null
                    ? Image.asset(
                        selectedOption?.image ?? component.images.first,
                        fit: BoxFit.cover,
                        cacheWidth: 240,
                        errorBuilder: (_, _, _) => Icon(
                          component.category.icon,
                          size: 32,
                          color: BBColors.readable(context, categoryColor),
                        ),
                      )
                    : Icon(
                        component.category.icon,
                        size: 32,
                        color: BBColors.readable(context, categoryColor),
                      ),
              ),
            ),
            const SizedBox(width: BBColors.padM),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          component.name,
                          style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (component.discountLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: BBColors.accentRed.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(BBColors.radiusSm),
                          ),
                          child: Text(
                            component.discountLabel!,
                            style: BBTextResponsive.labelSmall(context, color: BBColors.accentRed, weight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                  Text(component.brand, style: BBTextResponsive.caption(context)),
                  const SizedBox(height: BBColors.padS),
                  // Selected option
                  if (isSelected && selectedOption != null) ...[
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: selectedOption!.colorHex != null
                                                            ? Color(int.parse(selectedOption!.colorHex!.replaceFirst('#', '0xFF')))
                                                            : categoryColor,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Theme.of(context).brightness == Brightness.dark ? BBColors.nightBorder : BBColors.dayBorder,
                                                          width: 1,
                                                        ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(child: Text(
                          selectedOption!.name,
                          style: BBTextResponsive.bodySmall(context, weight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  // Price
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        context.money((selectedOption?.price ?? component.price)),
                        style: BBTextResponsive.titleMedium(context, color: categoryColor, weight: FontWeight.w700),
                      ),
                      if ((selectedOption?.originalPrice ?? component.originalPrice ?? 0) > (selectedOption?.price ?? component.price)) ...[
                        Text(
                          context.money((selectedOption?.originalPrice ?? component.originalPrice!)),
                          style: BBTextResponsive.bodySmall(context).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Selection indicator / Clear
            if (isSelected && onClear != null)
              IconButton(
                icon: Icon(Icons.clear_rounded, color: BBColors.textMuted(context), size: 20),
                onPressed: onClear,
                tooltip: 'Remove',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                padding: EdgeInsets.zero,
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isSelected
                    ? BBColors.readable(context, categoryColor)
                    : BBColors.textMuted(context),
              ),
          ],
        ),
      ),
    );
  }
}

class _ComponentOptionSheet extends StatelessWidget {
  final Component component;
  final ComponentOption? selectedOption;
  final void Function(ComponentOption) onSelect;

  const _ComponentOptionSheet({
    required this.component,
    required this.selectedOption,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? BBColors.nightBg : BBColors.dayBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(BBColors.radiusXl)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: BBColors.padM),
              decoration: BoxDecoration(
                color: BBColors.textMuted(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(BBColors.padXL, 0, BBColors.padXL, BBColors.padM),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          component.name,
                          style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600),
                        ),
                        Text(
                          'Select ${component.category.label.toLowerCase()} variant',
                          style: BBTextResponsive.bodySmall(context),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Options
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(BBColors.padL),
                itemCount: component.options.length,
                itemBuilder: (context, index) {
                  final option = component.options[index];
                  final isSelected = selectedOption?.id == option.id;

                  return GestureDetector(
                    onTap: () {
                      onSelect(option);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: BBColors.padM),
                      padding: const EdgeInsets.all(BBColors.padM),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? component.category.color.withValues(alpha: 0.1)
                            : (isDark ? BBColors.nightSurface : BBColors.daySurface),
                        borderRadius: BorderRadius.circular(BBColors.radiusLg),
                        border: Border.all(
                          color: isSelected
                              ? component.category.color
                              : (isDark ? BBColors.nightDivider : BBColors.dayDivider),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Variant photo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(BBColors.radiusMd),
                            child: option.image != null
                                ? Image.asset(option.image!, width: 56, height: 56, fit: BoxFit.cover, cacheWidth: 168)
                                : Container(width: 56, height: 56, color: component.category.color),
                          ),
                          const SizedBox(width: BBColors.padM),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option.name,
                                        style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: BBColors.readable(
                                          context,
                                          component.category.color,
                                        ),
                                        size: 20,
                                      ),
                                  ],
                                ),
                                if (option.specs != null && option.specs!.isNotEmpty)
                                  Text(
                                    option.specs!.entries.map((e) => '${e.key}: ${e.value}').join(' • '),
                                    style: BBTextResponsive.caption(context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          // Price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                context.money((option.price ?? 0)),
                                style: BBTextResponsive.titleMedium(context, weight: FontWeight.w700, color: component.category.color),
                              ),
                              if (option.originalPrice != null && option.originalPrice! > (option.price ?? 0))
                                Text(
                                  context.money(option.originalPrice!),
                                  style: BBTextResponsive.caption(context).copyWith(decoration: TextDecoration.lineThrough),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildActionBar extends StatelessWidget {
  final BuildProvider buildProvider;

  const _BuildActionBar({required this.buildProvider});

  @override
  Widget build(BuildContext context) {
    final build = buildProvider.currentBuild;
    final isComplete = build?.isComplete ?? false;
    final totalPrice = build?.totalPrice ?? 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(BBColors.padL, BBColors.padM, BBColors.padL, BBColors.padL),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: BrandButton.outline(
                text: 'Save',
                icon: Icons.save_rounded,
                onPressed: () => _saveBuild(context),
              ),
            ),
            const SizedBox(width: BBColors.padM),
            Expanded(
              flex: 2,
              child: BrandButton(
                text: isComplete ? 'Add to Cart (${context.money(totalPrice)})' : 'Complete Build First',
                icon: Icons.shopping_cart_rounded,
                onPressed: isComplete ? () => _addToCart(context) : null,
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBuild(BuildContext context) async {
    final controller = TextEditingController(text: buildProvider.currentBuild?.name ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Save build'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Build name'),
          onSubmitted: (v) => Navigator.pop(dialogContext, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text), child: const Text('Save')),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty) return;
    buildProvider.setBuildName(name.trim());
    await buildProvider.saveBuild();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Saved "${name.trim()}" to your builds'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _addToCart(BuildContext context) async {
    final build = buildProvider.currentBuild;
    if (build == null || !build.isComplete) return;
    await context.read<CartProvider>().addBuild(build);
    if (!context.mounted) return;
    goToTab(context, 2);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${build.componentCount} parts added to your cart'),
      behavior: SnackBarBehavior.floating,
    ));
  }
}