import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/brand_button.dart';
import '../../models/app_models.dart';
import '../../providers/cart_provider.dart';
import '../../providers/shop_provider.dart';
import 'main/main_screen.dart';

/// Adds one unit (default variant unless given) to the cart and confirms with a snackbar.
void addToCartWithFeedback(BuildContext context, Component component, [ComponentOption? option]) {
  option ??= component.options.where((o) => o.isDefault).firstOrNull ?? component.options.firstOrNull;
  context.read<CartProvider>().addItem(CartItem(
        id: '${component.id}_${option?.id}_${DateTime.now().millisecondsSinceEpoch}',
        component: component,
        selectedOption: option?.name,
        option: option,
        quantity: 1,
      ));
  final navigator = Navigator.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('${component.name}${option == null ? '' : ' (${option.name})'} added to cart'),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'View Cart',
        onPressed: () {
          navigator.popUntil((route) => route.isFirst);
          mainTab.value = 2;
        },
      ),
    ));
}

class ProductDetailScreen extends StatefulWidget {
  final Component component;

  const ProductDetailScreen({super.key, required this.component});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ComponentOption? _option =
      widget.component.options.where((o) => o.isDefault).firstOrNull ?? widget.component.options.firstOrNull;

  Component get component => widget.component;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = component.category.color;
    final shop = context.watch<ShopProvider>();
    final isFavorite = shop.isFavorite(component.id);
    final price = _option?.price ?? component.price;
    final originalPrice = _option == null ? component.originalPrice : _option!.originalPrice;
    final image = _option?.image ?? component.images.firstOrNull;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton.filledTonal(
                tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                onPressed: () => shop.toggleFavorite(component.id),
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? BBColors.danger : null,
                ),
              ),
              const SizedBox(width: BBColors.padS),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                children: [
                  // Main Image
                  Positioned.fill(
                    child: AnimatedSwitcher(
                      duration: BBColors.animNormal,
                      switchInCurve: Curves.easeOutCubic,
                      child: image != null
                          ? Image.asset(
                              image,
                              key: ValueKey(image),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              semanticLabel: '${component.name}, ${_option?.name ?? ''}',
                              errorBuilder: (_, _, _) => _placeholderImage(categoryColor),
                            )
                          : _placeholderImage(categoryColor),
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            (isDark ? BBColors.nightBg : BBColors.dayBg).withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badges
                  Positioned(
                    top: BBColors.padL + MediaQuery.of(context).padding.top,
                    left: BBColors.padL,
                    child: _CategoryBadge(category: component.category),
                  ),
                  if (component.discountLabel != null)
                    Positioned(
                      bottom: BBColors.padL,
                      left: BBColors.padL,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: BBColors.accentRed,
                          borderRadius: BorderRadius.circular(BBColors.radiusLg),
                        ),
                        child: Text(
                          component.discountLabel!,
                          style: BBTextResponsive.labelSmall(context, color: Colors.white, weight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(BBColors.padL),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Name & Brand
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            component.brand,
                            style: BBTextResponsive.labelLarge(context, color: categoryColor, weight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            component.name,
                            style: BBTextResponsive.headlineLarge(context, weight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 18, color: BBColors.accentOrange),
                        const SizedBox(width: 4),
                        Text(
                          component.rating.toStringAsFixed(1),
                          style: BBTextResponsive.titleMedium(context, weight: FontWeight.w600),
                        ),
                        Text(
                          ' (${component.reviewCount})',
                          style: BBTextResponsive.bodyMedium(context, color: BBColors.textMuted(context)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: BBColors.padL),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: BBColors.padM,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Text(
                            context.money(price),
                            style: BBTextResponsive.displayLarge(context, color: categoryColor, weight: FontWeight.w800, size: 32),
                          ),
                          if (originalPrice != null && originalPrice > price)
                            Text(
                              context.money(originalPrice),
                              style: BBTextResponsive.titleMedium(context).copyWith(decoration: TextDecoration.lineThrough),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: BBColors.padM),
                    _StockBadge(stock: component.stockCount),
                  ],
                ),
                const SizedBox(height: BBColors.padXL),

                // Description
                Text('Description', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
                const SizedBox(height: BBColors.padM),
                Text(component.description, style: BBTextResponsive.bodyLarge(context).copyWith(height: 1.6)),
                const SizedBox(height: BBColors.padXL),

                // Specs
                if (component.specs.isNotEmpty) ...[
                  Text('Specifications', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
                  const SizedBox(height: BBColors.padM),
                  BrandCard(
                    padding: const EdgeInsets.all(BBColors.padL),
                    child: Column(
                      children: component.specs.entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(entry.key, style: BBTextResponsive.bodyMedium(context))),
                            const SizedBox(width: BBColors.padM),
                            Expanded(
                              child: Text(
                                entry.value,
                                textAlign: TextAlign.end,
                                style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: BBColors.padXL),
                ],

                if (component.options.isNotEmpty) ...[
                  Text('Select Variant', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
                  const SizedBox(height: BBColors.padM),
                  _OptionSelector(
                    component: component,
                    onOptionSelected: (option) => setState(() => _option = option),
                  ),
                  const SizedBox(height: BBColors.padXL),
                ],

                BrandButton(
                  text: component.isInStock ? 'Add to Cart - ${context.money(price)}' : 'Out of Stock',
                  icon: Icons.shopping_cart_rounded,
                  onPressed: component.isInStock ? () => addToCartWithFeedback(context, component, _option) : null,
                  fullWidth: true,
                  height: 56,
                ),
                const SizedBox(height: BBColors.padXXL),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage(Color categoryColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withValues(alpha: 0.2),
            categoryColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          component.category.icon,
          size: 80,
          color: categoryColor,
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final ComponentCategory category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(BBColors.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14, color: category.color),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: BBTextResponsive.labelSmall(context, color: Colors.white, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int stock;

  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    if (stock <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: BBColors.accentRed.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
          border: Border.all(color: BBColors.accentRed.withValues(alpha: 0.3)),
        ),
        child: Text(
          'Out of Stock',
          style: BBTextResponsive.labelSmall(context, color: BBColors.accentRed, weight: FontWeight.w600),
        ),
      );
    } else if (stock <= 5) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: BBColors.accentOrange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
          border: Border.all(color: BBColors.accentOrange.withValues(alpha: 0.3)),
        ),
        child: Text(
          'Only $stock left',
          style: BBTextResponsive.labelSmall(context, color: BBColors.accentOrange, weight: FontWeight.w600),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: BBColors.accentGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(BBColors.radiusLg),
      ),
      child: Text(
        'In Stock',
        style: BBTextResponsive.labelSmall(context, color: BBColors.accentGreen, weight: FontWeight.w600),
      ),
    );
  }
}

class _OptionSelector extends StatefulWidget {
  final Component component;
  final void Function(ComponentOption) onOptionSelected;

  const _OptionSelector({
    required this.component,
    required this.onOptionSelected,
  });

  @override
  State<_OptionSelector> createState() => _OptionSelectorState();
}

class _OptionSelectorState extends State<_OptionSelector> {
  late ComponentOption _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.component.options.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Color swatches
        if (widget.component.options.any((o) => o.colorHex != null)) ...[
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.component.options.length,
              separatorBuilder: (_, _) => const SizedBox(width: BBColors.padM),
              itemBuilder: (context, index) {
                final option = widget.component.options[index];
                final isSelected = _selectedOption.id == option.id;

                return GestureDetector(
                  onTap: () => setState(() => _selectedOption = option),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: option.colorHex != null
                          ? Color(int.parse(option.colorHex!.replaceFirst('#', '0xFF')))
                          : widget.component.category.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? widget.component.category.color
                            : (isDark ? BBColors.nightDivider : BBColors.dayDivider),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: widget.component.category.color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: BBColors.padL),
        ],
        // Option cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.component.options.length,
          separatorBuilder: (_, _) => const SizedBox(height: BBColors.padM),
          itemBuilder: (context, index) {
            final option = widget.component.options[index];
            final isSelected = _selectedOption.id == option.id;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedOption = option);
                widget.onOptionSelected(option);
              },
              child: BrandCard(
                variant: isSelected ? BrandCardVariant.gradient : BrandCardVariant.defaultCard,
                border: isSelected
                    ? Border.all(color: widget.component.category.color, width: 2)
                    : null,
                padding: const EdgeInsets.all(BBColors.padM),
                child: Row(
                  children: [
                    if (option.image != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(BBColors.radiusSm),
                        child: Image.asset(
                          option.image!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          cacheWidth: 144,
                          errorBuilder: (_, _, _) => const SizedBox(width: 48, height: 48),
                        ),
                      ),
                      const SizedBox(width: BBColors.padM),
                    ],
                    // Color indicator
                    if (option.colorHex != null) ...[
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(int.parse(option.colorHex!.replaceFirst('#', '0xFF'))),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? BBColors.nightBorder : BBColors.dayBorder,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: BBColors.padM),
                    ],
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.name,
                            style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600),
                          ),
                          if (option.specs != null && option.specs!.isNotEmpty)
                            Text(
                              option.specs!.entries.map((e) => '${e.key}: ${e.value}').join(' • '),
                              style: BBTextResponsive.caption(context),
                            ),
                        ],
                      ),
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          context.money(option.price ?? widget.component.price),
                          style: BBTextResponsive.titleMedium(context, weight: FontWeight.w700, color: widget.component.category.color),
                        ),
                        if (option.originalPrice != null && option.price != null && option.originalPrice! > option.price!)
                          Text(
                            context.money(option.originalPrice!),
                            style: BBTextResponsive.caption(context).copyWith(decoration: TextDecoration.lineThrough),
                          ),
                      ],
                    ),
                    const SizedBox(width: BBColors.padM),
                    // Selection indicator
                    Icon(
                      isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? widget.component.category.color : BBColors.textMuted(context),
                      size: 24,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}