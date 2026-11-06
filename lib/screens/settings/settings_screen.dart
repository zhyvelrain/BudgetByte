import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_button.dart';
import '../../widgets/brand_card.dart';
import '../../providers/theme_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/build_provider.dart';
import '../../services/preferences_service.dart';
import '../../services/component_data_service.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/saved_builds_screen.dart';
import '../../screens/orders/orders_screen.dart';
import '../product_detail_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? BBColors.nightBg : BBColors.dayBg,
      appBar: AppBar(
        title: Text('Settings', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
        backgroundColor: isDark ? BBColors.nightSurface : BBColors.daySurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBColors.padL),
        children: [
          // Account Section
          _SectionHeader(title: 'Account', color: BBColors.accentBlue),
          BrandCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  subtitle: 'Manage your account',
                  onTap: () => _showProfileDialog(context),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.favorite_outline_rounded,
                  title: 'Favorites',
                  subtitle: 'View saved components',
                  onTap: () => _showFavorites(context),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.history_rounded,
                  title: 'Order History',
                  subtitle: 'Track past purchases',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.build_rounded,
                  title: 'Saved Builds',
                  subtitle: 'Manage your custom builds',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedBuildsScreen())),
                ),
              ],
            ),
          ),

          const SizedBox(height: BBColors.space24),

          // Preferences Section
          _SectionHeader(title: 'Preferences', color: BBColors.catMonitor),
          BrandCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Theme',
                  subtitle: 'Light, Dark, or System',
                  onTap: () => _showThemeDialog(context),
                  trailing: Consumer<ThemeProvider>(
                    builder: (context, provider, _) => Text(
                      _themeLabel(provider.themeMode),
                      style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context)),
                    ),
                  ),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English (US)',
                  onTap: () => _showLanguageDialog(context),
                ),
                _divider(context),
                Consumer<ThemeProvider>(
                  builder: (context, provider, _) => SwitchListTile(
                    secondary: Icon(Icons.nightlight_round, color: BBColors.textSecondary(context)),
                    title: Text('Dark Mode', style: BBTextResponsive.bodyLarge(context)),
                    subtitle: Text('Use dark theme', style: BBTextResponsive.bodySmall(context)),
                    value: provider.themeMode == ThemeMode.dark,
                    activeThumbColor: BBColors.accentBlue,
                    onChanged: (value) => provider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
                    contentPadding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: BBColors.space24),

          // Notifications Section
          _SectionHeader(title: 'Notifications', color: BBColors.catAudio),
          BrandCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.shopping_cart_outlined, color: BBColors.textSecondary(context)),
                  title: Text('Cart Updates', style: BBTextResponsive.bodyLarge(context)),
                  subtitle: Text('Price drops & restock alerts', style: BBTextResponsive.bodySmall(context)),
                  value: true,
                  activeThumbColor: BBColors.accentBlue,
                  onChanged: (value) => _showNotificationSettings(context, 'cart'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
                ),
                _divider(context),
                SwitchListTile(
                  secondary: Icon(Icons.local_offer_outlined, color: BBColors.textSecondary(context)),
                  title: Text('Promotions', style: BBTextResponsive.bodyLarge(context)),
                  subtitle: Text('Sales & special offers', style: BBTextResponsive.bodySmall(context)),
                  value: true,
                  activeThumbColor: BBColors.accentBlue,
                  onChanged: (value) => _showNotificationSettings(context, 'promo'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
                ),
                _divider(context),
                SwitchListTile(
                  secondary: Icon(Icons.build_rounded, color: BBColors.textSecondary(context)),
                  title: Text('Build Updates', style: BBTextResponsive.bodyLarge(context)),
                  subtitle: Text('New components & compatibility', style: BBTextResponsive.bodySmall(context)),
                  value: true,
                  activeThumbColor: BBColors.accentBlue,
                  onChanged: (value) => _showNotificationSettings(context, 'build'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
                ),
              ],
            ),
          ),

          const SizedBox(height: BBColors.space24),

          // Data & Storage Section
          _SectionHeader(title: 'Data & Storage', color: BBColors.catCamera),
          BrandCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.cloud_download_outlined,
                  title: 'Export Data',
                  subtitle: 'Download your builds & orders',
                  onTap: () => _exportData(context),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Import Data',
                  subtitle: 'Restore from backup file',
                  onTap: () => _importData(context),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.delete_sweep_outlined,
                  title: 'Clear All Data',
                  subtitle: 'Cart, builds, history, favorites',
                  iconColor: BBColors.danger,
                  textColor: BBColors.danger,
                  onTap: () => _confirmClearData(context),
                ),
                _divider(context),
                Consumer<BuildProvider>(
                  builder: (context, buildProvider, _) => ListTile(
                    leading: Icon(Icons.storage_rounded, color: BBColors.textSecondary(context)),
                    title: Text('Storage Used', style: BBTextResponsive.bodyLarge(context)),
                    subtitle: Text(
                      '\${(buildProvider.savedBuilds.length * 2)} KB (\${buildProvider.savedBuilds.length} builds)',
                      style: BBTextResponsive.bodySmall(context),
                    ),
                    trailing: TextButton(
                      onPressed: () => _showStorageDetails(context),
                      child: Text('Details', style: BBTextResponsive.bodySmall(context, color: BBColors.accentBlue)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: BBColors.space24),

          // App Section
          _SectionHeader(title: 'App', color: BBColors.catKeyboard),
          BrandCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.tour_outlined,
                  title: 'App Tour',
                  subtitle: 'Replay the onboarding walkthrough',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OnboardingScreen(onComplete: () {})),
                  ),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & FAQ',
                  subtitle: 'Common questions & guides',
                  onTap: () => _showHelpDialog(context),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Report a Bug',
                  subtitle: 'Submit feedback or issues',
                  onTap: () => _showBugReportDialog(context),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.share_rounded,
                  title: 'Share App',
                  subtitle: 'Recommend to friends',
                  onTap: () => _shareApp(context),
                ),
                _divider(context),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About ByteBudget',
                  subtitle: 'Version 1.0.0 • Build 100',
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: BBColors.space32),

          // Version footer
          Center(
            child: Text(
              'ByteBudget v1.0.0+100',
              style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context)),
            ),
          ),
          const SizedBox(height: BBColors.padL),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Widget _divider(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: BBColors.padL),
        child: Divider(height: 1, color: BBColors.divider(context)),
      );

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('Profile', style: BBTextResponsive.titleLarge(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: BBColors.accentBlueSoft,
              child: Icon(Icons.person_rounded, size: 40, color: BBColors.accentBlue),
            ),
            const SizedBox(height: BBColors.padM),
            Text('Guest User', style: BBTextResponsive.titleMedium(context, weight: FontWeight.w600)),
            Text('Not signed in', style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context))),
            const SizedBox(height: BBColors.padM),
            BrandButton(
              text: 'Sign In',
              icon: Icons.login_rounded,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign in coming soon!', style: BBTextResponsive.bodyMedium(context))),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showFavorites(BuildContext context) {
    final navigator = Navigator.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(BBColors.radiusXl)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: BBColors.padM),
                decoration: BoxDecoration(
                  color: BBColors.textMuted(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(BBColors.padL),
                child: Row(
                  children: [
                    Text('Favorites', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Done', style: BBTextResponsive.bodyMedium(context, color: BBColors.accentBlue)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: FutureBuilder<Set<String>>(
                  future: PreferencesService.getFavorites(),
                  builder: (context, snapshot) {
                    final favorites = snapshot.data ?? <String>{};
                    if (favorites.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border_rounded, size: 64, color: BBColors.textMuted(context)),
                            const SizedBox(height: BBColors.padM),
                            Text('No favorites yet', style: BBTextResponsive.titleMedium(context, color: BBColors.textMuted(context))),
                            const SizedBox(height: BBColors.padS),
                            Text('Tap the heart on any component', style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context))),
                          ],
                        ),
                      );
                    }
                    final favoritesList = favorites.toList();
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(BBColors.padL),
                      itemCount: favoritesList.length,
                      itemBuilder: (context, index) {
                        final compId = favoritesList[index];
                        final component = ComponentDataService.getById(compId);
                        if (component == null) return const SizedBox();
                        return ListTile(
                          leading: component.images.isNotEmpty
                              ? Image.asset(component.images.first, width: 48, height: 48, fit: BoxFit.cover)
                              : Icon(component.category.icon, color: component.category.color, size: 32),
                          title: Text(component.name, style: BBTextResponsive.bodyMedium(context)),
                          subtitle: Text('\${component.brand} • ₱\${component.price.toStringAsFixed(2)}', style: BBTextResponsive.bodySmall(context)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline_rounded, color: BBColors.danger),
                            onPressed: () async {
                              await PreferencesService.toggleFavorite(compId);
                              if (!context.mounted) return;
                              navigator.pop();
                              _showFavorites(context);
                            },
                          ),
                          onTap: () {
                            navigator.pop();
                            navigator.push(
                              MaterialPageRoute(builder: (_) => ProductDetailScreen(component: component)),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final provider = context.read<ThemeProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('Choose Theme', style: BBTextResponsive.titleLarge(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              icon: Icons.light_mode_rounded,
              title: 'Light',
              subtitle: 'Always light mode',
              isSelected: provider.themeMode == ThemeMode.light,
              onTap: () {
                provider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              icon: Icons.dark_mode_rounded,
              title: 'Dark',
              subtitle: 'Always dark mode',
              isSelected: provider.themeMode == ThemeMode.dark,
              onTap: () {
                provider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              icon: Icons.brightness_auto_rounded,
              title: 'System',
              subtitle: 'Follow device setting',
              isSelected: provider.themeMode == ThemeMode.system,
              onTap: () {
                provider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('Language', style: BBTextResponsive.titleLarge(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(flag: '🇺🇸', name: 'English (US)', code: 'en_US', onTap: () => Navigator.pop(context)),
            _LanguageOption(flag: '🇬🇧', name: 'English (UK)', code: 'en_GB', onTap: () => Navigator.pop(context)),
            _LanguageOption(flag: '🇵🇭', name: 'Tagalog', code: 'tl_PH', onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification settings for \$type coming soon!', style: BBTextResponsive.bodyMedium(context)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export functionality coming soon!', style: BBTextResponsive.bodyMedium(context)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _importData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Import functionality coming soon!', style: BBTextResponsive.bodyMedium(context)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmClearData(BuildContext context) {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final cartProvider = context.read<CartProvider>();
    final buildProvider = context.read<BuildProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('Clear All Data?', style: BBTextResponsive.titleLarge(context, color: BBColors.danger)),
        content: Text(
          'This will permanently delete your cart, saved builds, order history, and favorites. This cannot be undone.',
          style: BBTextResponsive.bodyMedium(context),
        ),
        actions: [
          TextButton(onPressed: () => navigator.pop(), child: const Text('Cancel')),
          BrandButton(
            text: 'Clear Everything',
            variant: BrandButtonVariant.secondary,
            onPressed: () async {
              navigator.pop();
              await PreferencesService.clearAllData();
              cartProvider.clear();
              buildProvider.startNewBuild();
              if (!context.mounted) return;
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('All data cleared', style: BBTextResponsive.bodyMedium(context)),
                  backgroundColor: BBColors.accentGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showStorageDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('Storage Details', style: BBTextResponsive.titleLarge(context)),
        content: Consumer<BuildProvider>(
          builder: (context, buildProvider, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StorageRow(label: 'Saved Builds', value: '\${buildProvider.savedBuilds.length} builds (~\${buildProvider.savedBuilds.length * 2} KB)'),
              _StorageRow(label: 'Cart Items', value: '\${context.read<CartProvider>().itemCount} items'),
              _StorageRow(label: 'Favorites', value: 'Loading...'),
              _StorageRow(label: 'App Cache', value: '~2.4 MB'),
              const Divider(height: BBColors.space16),
              _StorageRow(label: 'Total', value: '~\${2400 + buildProvider.savedBuilds.length * 2} KB', isTotal: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('Help & FAQ', style: BBTextResponsive.titleLarge(context)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HelpItem(
                question: 'How do I build a PC?',
                answer: 'Go to the Builder tab, select components for each category, then tap "Add to Cart" when complete.',
              ),
              _HelpItem(
                question: 'Can I save my builds?',
                answer: 'Yes! Tap "Save Build" in the builder to save your configuration for later.',
              ),
              _HelpItem(
                question: 'How do I change the theme?',
                answer: 'Go to Settings > Preferences > Theme to choose Light, Dark, or System.',
              ),
              _HelpItem(
                question: 'What currency is used?',
                answer: 'All prices are in Philippine Peso (₱). Currency selection is not available.',
              ),
              _HelpItem(
                question: 'How do I clear my data?',
                answer: 'Settings > Data & Storage > Clear All Data. This removes cart, builds, history, and favorites.',
              ),
              _HelpItem(
                question: 'Where can I get support?',
                answer: 'Use "Report a Bug" in Settings or email support@bytebudget.ph',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('Report a Bug', style: BBTextResponsive.titleLarge(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Describe the issue you encountered:', style: BBTextResponsive.bodyMedium(context)),
            const SizedBox(height: BBColors.padM),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Steps to reproduce, expected vs actual behavior...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(BBColors.radiusMd)),
              ),
            ),
            const SizedBox(height: BBColors.padM),
            Text('We\'ll review your report and get back to you.', style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          BrandButton(
            text: 'Submit Report',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bug report submitted!', style: BBTextResponsive.bodyMedium(context)),
                  backgroundColor: BBColors.accentGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share feature coming soon!', style: BBTextResponsive.bodyMedium(context)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BBColors.radiusXl)),
        title: Text('About ByteBudget', style: BBTextResponsive.titleLarge(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0+100', style: BBTextResponsive.bodyMedium(context)),
            const SizedBox(height: BBColors.padS),
            Text('Build your dream PC setup with curated components.', style: BBTextResponsive.bodySmall(context)),
            const SizedBox(height: BBColors.padS),
            Text('© 2024 ByteBudget. All rights reserved.', style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: BBColors.padS, bottom: BBColors.padS),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: BBColors.padS),
          Text(title, style: BBTextResponsive.titleMedium(context, weight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? BBColors.accentBlue).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
        ),
        child: Icon(icon, color: iconColor ?? BBColors.accentBlue, size: 22),
      ),
      title: Text(title, style: BBTextResponsive.bodyLarge(context, color: textColor, weight: FontWeight.w500)),
      subtitle: Text(subtitle, style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context))),
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: BBColors.textMuted(context)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(BBColors.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(BBColors.padM),
        margin: const EdgeInsets.symmetric(vertical: BBColors.padS),
        decoration: BoxDecoration(
          color: isSelected ? BBColors.accentBlueSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          border: Border.all(
            color: isSelected ? BBColors.accentBlue : BBColors.divider(context),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? BBColors.accentBlue : BBColors.surfaceAlt(context),
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : BBColors.textSecondary(context), size: 22),
            ),
            const SizedBox(width: BBColors.padM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: BBTextResponsive.bodyLarge(context, weight: FontWeight.w600)),
                  Text(subtitle, style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context))),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: BBColors.accentBlue, size: 24),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String name;
  final String code;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.name,
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(BBColors.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(BBColors.padM),
        margin: const EdgeInsets.symmetric(vertical: BBColors.padS),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: BBColors.padM),
            Expanded(child: Text(name, style: BBTextResponsive.bodyLarge(context))),
          ],
        ),
      ),
    );
  }
}

class _StorageRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _StorageRow({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BBColors.padS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: BBTextResponsive.bodyMedium(context, weight: isTotal ? FontWeight.w600 : FontWeight.w400)),
          Text(value, style: BBTextResponsive.bodyMedium(context, weight: isTotal ? FontWeight.w600 : FontWeight.w400, color: isTotal ? BBColors.accentBlue : BBColors.textSecondary(context))),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String question;
  final String answer;

  const _HelpItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BBColors.padM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600)),
          const SizedBox(height: BBColors.padXS),
          Text(answer, style: BBTextResponsive.bodySmall(context, color: BBColors.textSecondary(context))),
        ],
      ),
    );
  }
}