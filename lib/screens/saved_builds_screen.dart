import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/brand_button.dart';
import '../../models/app_models.dart';
import '../../services/preferences_service.dart';
import '../../providers/build_provider.dart';
import '../../providers/cart_provider.dart';
import 'builder/builder_screen.dart';

class SavedBuildsScreen extends StatelessWidget {
  const SavedBuildsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Builds', style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BuilderScreen()),
            ),
            tooltip: 'Create New Build',
          ),
        ],
      ),
      body: FutureBuilder<List<BuildConfig>>(
        future: PreferencesService.getBuilds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final builds = snapshot.data ?? [];

          if (builds.isEmpty) {
            return _EmptyState(
              icon: Icons.build_circle_rounded,
              title: 'No Saved Builds',
              subtitle: 'Create and save your custom PC builds',
              actionText: 'Start Building',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuilderScreen()),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(BBColors.padL),
            itemCount: builds.length,
            separatorBuilder: (_, _) => const SizedBox(height: BBColors.padM),
            itemBuilder: (context, index) {
              final build = builds[index];
              return _BuildCard(buildConfig: build);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BuilderScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: Text('New Build', style: BBTextResponsive.labelLarge(context)),
        backgroundColor: BBColors.accentBlue,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BBColors.padXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: BBColors.textMuted(context)),
            ),
            const SizedBox(height: BBColors.padXL),
            Text(title, style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600)),
            const SizedBox(height: BBColors.padS),
            Text(subtitle, style: BBTextResponsive.bodyLarge(context, color: BBColors.textMuted(context)), textAlign: TextAlign.center),
            const SizedBox(height: BBColors.padXL),
            BrandButton(text: actionText, icon: Icons.build_rounded, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}

class _BuildCard extends StatelessWidget {
  final BuildConfig buildConfig;

  const _BuildCard({required this.buildConfig});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completed = buildConfig.selectedComponents.values.where((c) => c != null).length;
    final total = ComponentCategory.values.length;
    final progress = completed / total;

    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buildConfig.name, style: BBTextResponsive.titleMedium(context, weight: FontWeight.w600)),
                    Text('Updated ${_formatDate(buildConfig.updatedAt)}', style: BBTextResponsive.caption(context)),
                  ],
                ),
              ),
              // Progress indicator
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: isDark ? BBColors.nightBorder : BBColors.dayBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        buildConfig.isComplete ? BBColors.accentGreen : BBColors.accentBlue,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: BBTextResponsive.labelSmall(context, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: BBColors.padM),
          // Selected components preview
          Wrap(
            spacing: BBColors.padS,
            runSpacing: BBColors.padS,
            children: buildConfig.selectedComponents.entries
                .where((e) => e.value != null)
                .map((entry) {
              final component = entry.value!;
              // BuildConfig doesn't store selectedOption per component, so pass null
              return _ComponentChip(
                component: component,
                option: null,
              );
            }).toList(),
          ),
          if (buildConfig.selectedComponents.values.every((v) => v == null))
            Text(
              'No components selected',
              style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context)),
            ),
          const SizedBox(height: BBColors.padM),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${buildConfig.totalPrice.toStringAsFixed(2)}',
                style: BBTextResponsive.titleLarge(context, weight: FontWeight.w700, color: BBColors.accentBlue),
              ),
              Row(
                children: [
                  if (!buildConfig.isComplete)
                    BrandButton.outline(
                      text: 'Continue',
                      onPressed: () => _loadBuild(context, buildConfig),
                    ),
                  if (!buildConfig.isComplete) const SizedBox(width: BBColors.padS),
                  BrandButton(
                    text: buildConfig.isComplete ? 'Add to Cart' : 'Edit',
                    onPressed: () => buildConfig.isComplete
                        ? _addToCart(context, buildConfig)
                        : _loadBuild(context, buildConfig),
                  ),
                  const SizedBox(width: BBColors.padS),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: BBColors.textMuted(context)),
                    onSelected: (value) => _handleMenuAction(context, value, buildConfig),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                      const PopupMenuItem(value: 'rename', child: Text('Rename')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _loadBuild(BuildContext context, BuildConfig buildConfig) {
    final buildProvider = context.read<BuildProvider>();
    buildProvider.loadBuild(buildConfig.id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BuilderScreen()),
    );
  }

  void _addToCart(BuildContext context, BuildConfig buildConfig) {
    final cartProvider = context.read<CartProvider>();
    for (final entry in buildConfig.selectedComponents.entries) {
      final component = entry.value;
      if (component != null) {
        cartProvider.addItem(CartItem(
          id: '${component.id}_${DateTime.now().millisecondsSinceEpoch}',
          component: component,
          quantity: 1,
        ));
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Build added to cart!', style: BBTextResponsive.bodyMedium(context)),
        backgroundColor: BBColors.accentGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action, BuildConfig buildConfig) async {
    switch (action) {
      case 'duplicate':
        final newBuild = buildConfig.copyWith(
          id: 'build_${DateTime.now().millisecondsSinceEpoch}',
          name: '${buildConfig.name} (Copy)',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await PreferencesService.addBuild(newBuild);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Build duplicated'), backgroundColor: BBColors.accentGreen),
          );
        }
        break;
      case 'rename':
        _showRenameDialog(context, buildConfig);
        break;
      case 'delete':
        _showDeleteDialog(context, buildConfig.id);
        break;
    }
  }

  void _showRenameDialog(BuildContext context, BuildConfig buildConfig) {
    final controller = TextEditingController(text: buildConfig.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Build', style: BBTextResponsive.titleLarge(context)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Build Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: BBTextResponsive.labelMedium(context)),
          ),
          BrandButton(
            text: 'Save',
            onPressed: () async {
              final newBuild = buildConfig.copyWith(name: controller.text, updatedAt: DateTime.now());
              await PreferencesService.updateBuild(newBuild);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String buildId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Build', style: BBTextResponsive.titleLarge(context)),
        content: Text('This action cannot be undone.', style: BBTextResponsive.bodyMedium(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: BBTextResponsive.labelMedium(context)),
          ),
          BrandButton.outline(
            text: 'Delete',
            foregroundColor: BBColors.accentRed,
            onPressed: () async {
              await PreferencesService.deleteBuild(buildId);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return '${diff.inMinutes}m ago';
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _ComponentChip extends StatelessWidget {
  final Component component;
  final ComponentOption? option;

  const _ComponentChip({required this.component, this.option});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: component.category.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(BBColors.radiusLg),
        border: Border.all(color: component.category.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(component.category.icon, size: 14, color: component.category.color),
          const SizedBox(width: 4),
          Text(
            component.name,
            style: BBTextResponsive.labelSmall(context, weight: FontWeight.w600, color: component.category.color),
          ),
          if (option != null) ...[
            const SizedBox(width: 4),
            Text(
              '• ${option!.name}',
              style: BBTextResponsive.labelSmall(context, color: BBColors.textMuted(context)),
            ),
          ],
        ],
      ),
    );
  }
}