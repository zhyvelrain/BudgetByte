import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';
import '../theme/bb_colors.dart';
import '../theme/bb_text.dart';
import '../widgets/brand_card.dart';
import '../widgets/brand_button.dart';
import '../models/app_models.dart';
import '../providers/build_provider.dart';
import '../providers/cart_provider.dart';
import 'main/main_screen.dart';

/// Saved builds ("build history"). Reads and writes through [BuildProvider] so
/// every change shows up immediately.
class SavedBuildsScreen extends StatelessWidget {
  const SavedBuildsScreen({super.key});

  static void _newBuild(BuildContext context) {
    context.read<BuildProvider>().startNewBuild();
    goToTab(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    final builds = context.watch<BuildProvider>().savedBuilds;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Builds',
          style: BBTextResponsive.headlineMedium(
            context,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: builds.isEmpty
          ? _EmptyState(
              icon: Icons.build_circle_rounded,
              title: 'No saved builds',
              subtitle: 'Pick parts in the Builder, then tap Save Build.',
              actionText: 'Start building',
              onAction: () => _newBuild(context),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                BBColors.padL,
                BBColors.padL,
                BBColors.padL,
                96,
              ),
              itemCount: builds.length,
              separatorBuilder: (_, _) => const SizedBox(height: BBColors.padM),
              itemBuilder: (context, index) =>
                  _BuildCard(buildConfig: builds[index]),
            ),
      floatingActionButton: builds.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _newBuild(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New build'),
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
                gradient: isDark
                    ? BBColors.cardGradientDark
                    : BBColors.cardGradientLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: BBColors.readable(context, BBColors.accentBlue),
              ),
            ),
            const SizedBox(height: BBColors.padXL),
            Text(
              title,
              style: BBTextResponsive.headlineMedium(
                context,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: BBColors.padS),
            Text(
              subtitle,
              style: BBTextResponsive.bodyLarge(
                context,
                color: BBColors.textMuted(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBColors.padXL),
            BrandButton(
              text: actionText,
              icon: Icons.build_rounded,
              onPressed: onAction,
            ),
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
    final completed = buildConfig.componentCount;
    final total = ComponentCategory.values.length;

    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buildConfig.name,
                      style: BBTextResponsive.titleMedium(
                        context,
                        weight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completed of $total parts · updated ${_formatDate(buildConfig.updatedAt)}',
                      style: BBTextResponsive.bodySmall(
                        context,
                        color: BBColors.textMuted(context),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'More actions',
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: BBColors.textMuted(context),
                ),
                onSelected: (value) => _handleMenuAction(context, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Text('Duplicate'),
                  ),
                  const PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: BBColors.padM),
          ClipRRect(
            borderRadius: BorderRadius.circular(BBColors.radiusSm),
            child: LinearProgressIndicator(
              value: completed / total,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: BBColors.padM),
          if (completed == 0)
            Text(
              'No parts picked yet',
              style: BBTextResponsive.bodySmall(
                context,
                color: BBColors.textMuted(context),
              ),
            )
          else
            Wrap(
              spacing: BBColors.padS,
              runSpacing: BBColors.padS,
              children: [
                for (final c in buildConfig.components)
                  _ComponentChip(component: c),
              ],
            ),
          const SizedBox(height: BBColors.padL),
          Text(
            context.money(buildConfig.totalPrice),
            style: BBTextResponsive.titleLarge(
              context,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: BBColors.padM),
          Row(
            children: [
              Expanded(
                child: BrandButton.outline(
                  text: buildConfig.isComplete ? 'Edit' : 'Continue',
                  onPressed: () => _open(context),
                  fullWidth: true,
                ),
              ),
              if (buildConfig.isComplete) ...[
                const SizedBox(width: BBColors.padM),
                Expanded(
                  child: BrandButton(
                    text: 'Add to Cart',
                    icon: Icons.add_shopping_cart_rounded,
                    onPressed: () => _addToCart(context),
                    fullWidth: true,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context) {
    context.read<BuildProvider>().loadBuild(buildConfig.id);
    goToTab(context, 1);
  }

  Future<void> _addToCart(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await context.read<CartProvider>().addBuild(buildConfig);
    if (!context.mounted) return;
    goToTab(context, 2);
    messenger.showSnackBar(
      SnackBar(
        content: Text('${buildConfig.componentCount} parts added to your cart'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    final builds = context.read<BuildProvider>();
    switch (action) {
      case 'duplicate':
        builds.duplicateBuild(buildConfig.id);
      case 'rename':
        _showRenameDialog(context, builds);
      case 'delete':
        _showDeleteDialog(context, builds);
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    BuildProvider builds,
  ) async {
    final controller = TextEditingController(text: buildConfig.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename build'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Build name'),
          onSubmitted: (v) => Navigator.pop(dialogContext, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name != null) await builds.renameBuild(buildConfig.id, name);
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    BuildProvider builds,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete "${buildConfig.name}"?'),
        content: const Text(
          'This removes the saved build. Items already in your cart stay there.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) await builds.deleteBuild(buildConfig.id);
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _ComponentChip extends StatelessWidget {
  final Component component;

  const _ComponentChip({required this.component});

  @override
  Widget build(BuildContext context) {
    final variant = component.options.length == 1
        ? component.options.first.name
        : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: component.category.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(BBColors.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            component.category.icon,
            size: 14,
            color: BBColors.readable(context, component.category.color),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              variant == null ? component.name : '${component.name} · $variant',
              style: BBTextResponsive.labelSmall(
                context,
                weight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
