import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import 'package:provider/provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/brand_button.dart';
import '../../providers/theme_provider.dart';
import '../../services/preferences_service.dart';
import '../../services/auth_service.dart';
import '../../models/app_models.dart';
import '../../services/component_data_service.dart';
import '../order_history_screen.dart';
import '../saved_builds_screen.dart';
import '../home/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: BBTextResponsive.headlineMedium(
            context,
            weight: FontWeight.w600,
          ),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: () => themeProvider.toggleTheme(),
              tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBColors.padL),
        children: [
          // Profile Header
          _ProfileHeader(),
          const SizedBox(height: BBColors.padXL),

          // Stats
          _StatsRow(),
          const SizedBox(height: BBColors.padXL),

          // Menu Sections
          _MenuSection(
            title: 'My Account',
            children: [
              _MenuItem(
                icon: Icons.history_rounded,
                title: 'Order History',
                subtitle: 'View past purchases',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                ),
              ),
              _MenuItem(
                icon: Icons.build_rounded,
                title: 'Saved Builds',
                subtitle: 'Your custom PC builds',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedBuildsScreen()),
                ),
              ),
              _MenuItem(
                icon: Icons.favorite_rounded,
                title: 'Wishlist',
                subtitle: 'Saved items for later',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: BBColors.padL),

          _MenuSection(
            title: 'Preferences',
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) => _MenuItem(
                  icon: themeProvider.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  subtitle: 'Toggle theme preference',
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                  onTap: () => themeProvider.toggleTheme(),
                ),
              ),
              _MenuItem(
                icon: Icons.attach_money_rounded,
                title: 'Currency',
                subtitle: ShopProvider
                    .currencies[context.watch<ShopProvider>().currency]!,
                onTap: () => showCurrencyPicker(context),
              ),
            ],
          ),
          const SizedBox(height: BBColors.padL),

          _MenuSection(
            title: 'About',
            children: [
              _MenuItem(
                icon: Icons.info_rounded,
                title: 'About ByteBudget',
                subtitle: 'Version 1.0.0',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          const SizedBox(height: BBColors.padXXL),

          // Sign out
          BrandButton.outline(
            text: 'Sign Out',
            icon: Icons.logout_rounded,
            foregroundColor: BBColors.readable(context, BBColors.accentRed),
            onPressed: () => _showSignOutDialog(context),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'ByteBudget',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: BrandAccents.electricGradient,
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
        ),
        child: const Icon(
          Icons.computer_rounded,
          size: 32,
          color: Colors.white,
        ),
      ),
      children: [
        Text(
          'Your ultimate PC peripheral companion. Build, compare, and shop for the best components.',
          style: BBTextResponsive.bodyMedium(context),
        ),
        const SizedBox(height: BBColors.padM),
        Text(
          'Built with Flutter • Material 3',
          style: BBTextResponsive.bodySmall(context),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out', style: BBTextResponsive.titleLarge(context)),
        content: Text(
          'Are you sure you want to sign out?',
          style: BBTextResponsive.bodyMedium(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: BBTextResponsive.labelMedium(context)),
          ),
          BrandButton.outline(
            text: 'Sign Out',
            foregroundColor: BBColors.readable(context, BBColors.accentRed),
            onPressed: () {
              final auth = context.read<AuthService>();
              Navigator.pop(context);
              auth.signOut();
            },
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    return BrandCard(
      gradient: LinearGradient(
        colors: [
          BBColors.accentBlue.withValues(alpha: 0.2),
          BBColors.accentTeal.withValues(alpha: 0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(BBColors.padXL),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: BrandAccents.electricGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: BBColors.padL),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BBTextResponsive.titleLarge(
                    context,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BBTextResponsive.bodyMedium(
                    context,
                    color: BBColors.textMuted(context),
                  ),
                ),
                const SizedBox(height: BBColors.padS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: BBColors.accentBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(BBColors.radiusSm),
                  ),
                  child: Text(
                    'Member since ${user?.createdAt.year ?? DateTime.now().year}',
                    style: BBTextResponsive.labelSmall(
                      context,
                      color: BBColors.accentBlue,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: PreferencesService.getOrders(),
      builder: (context, ordersSnapshot) {
        return FutureBuilder<List<BuildConfig>>(
          future: PreferencesService.getBuilds(),
          builder: (context, buildsSnapshot) {
            return FutureBuilder<Set<String>>(
              future: PreferencesService.getFavorites(),
              builder: (context, favoritesSnapshot) {
                if (ordersSnapshot.connectionState == ConnectionState.waiting ||
                    buildsSnapshot.connectionState == ConnectionState.waiting ||
                    favoritesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                  return Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.shopping_bag_rounded,
                          label: 'Orders',
                          value: '...',
                          color: BBColors.accentBlue,
                        ),
                      ),
                      const SizedBox(width: BBColors.padM),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.build_rounded,
                          label: 'Builds',
                          value: '...',
                          color: BBColors.catMouse,
                        ),
                      ),
                      const SizedBox(width: BBColors.padM),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.attach_money_rounded,
                          label: 'Spent',
                          value: '...',
                          color: BBColors.accentGreen,
                        ),
                      ),
                      const SizedBox(width: BBColors.padM),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.favorite_rounded,
                          label: 'Saved',
                          value: '...',
                          color: BBColors.accentRed,
                        ),
                      ),
                    ],
                  );
                }

                final orders = ordersSnapshot.data ?? [];
                final builds = buildsSnapshot.data ?? [];
                final favorites = favoritesSnapshot.data ?? <String>{};
                final totalSpent = orders.fold<double>(
                  0,
                  (sum, o) => sum + o.total,
                );

                return Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.shopping_bag_rounded,
                        label: 'Orders',
                        value: '${orders.length}',
                        color: BBColors.accentBlue,
                      ),
                    ),
                    const SizedBox(width: BBColors.padM),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.build_rounded,
                        label: 'Builds',
                        value: '${builds.length}',
                        color: BBColors.catMouse,
                      ),
                    ),
                    const SizedBox(width: BBColors.padM),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.attach_money_rounded,
                        label: 'Spent',
                        value: context.money(totalSpent),
                        color: BBColors.accentGreen,
                      ),
                    ),
                    const SizedBox(width: BBColors.padM),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.favorite_rounded,
                        label: 'Saved',
                        value: '${favorites.length}',
                        color: BBColors.accentRed,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padM),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(BBColors.radiusMd),
            ),
            child: Icon(
              icon,
              size: 20,
              color: BBColors.readable(context, color),
            ),
          ),
          const SizedBox(height: BBColors.padS),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: BBTextResponsive.titleMedium(
                context,
                weight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: BBTextResponsive.caption(context),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MenuSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: BBColors.padS,
            bottom: BBColors.padS,
          ),
          child: Text(
            title,
            style: BBTextResponsive.labelLarge(
              context,
              weight: FontWeight.w600,
              color: BBColors.accentBlue,
            ),
          ),
        ),
        BrandCard(
          padding: EdgeInsets.zero,
          child: Column(children: children.map((child) => child).toList()),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(BBColors.radiusMd),
      child: Padding(
        padding: const EdgeInsets.all(BBColors.padM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
              ),
              child: Icon(icon, size: 20, color: BBColors.textMuted(context)),
            ),
            const SizedBox(width: BBColors.padM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: BBTextResponsive.bodyMedium(
                      context,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: BBTextResponsive.caption(context)),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: BBColors.textMuted(context),
                ),
          ],
        ),
      ),
    );
  }
}

/// Lets the user switch the display currency (USD or PHP).
void showCurrencyPicker(BuildContext context) {
  final shop = context.read<ShopProvider>();
  showDialog(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title: Text(
        'Currency',
        style: BBTextResponsive.titleLarge(dialogContext),
      ),
      children: [
        for (final entry in ShopProvider.currencies.entries)
          ListTile(
            title: Text(entry.value),
            trailing: shop.currency == entry.key
                ? Icon(
                    Icons.check_rounded,
                    color: BBColors.readable(
                      dialogContext,
                      BBColors.accentBlue,
                    ),
                  )
                : null,
            selected: shop.currency == entry.key,
            onTap: () {
              shop.setCurrency(entry.key);
              Navigator.pop(dialogContext);
            },
          ),
      ],
    ),
  );
}

/// Favorited products.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<ShopProvider>().favorites;
    final products = ComponentDataService.components
        .where((c) => favorites.contains(c.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: BBTextResponsive.headlineMedium(
            context,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: products.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(BBColors.padXL),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 56,
                      color: BBColors.textMuted(context),
                    ),
                    const SizedBox(height: BBColors.padL),
                    Text(
                      'No favorites yet',
                      style: BBTextResponsive.titleLarge(
                        context,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: BBColors.padS),
                    Text(
                      'Tap the heart on any product to save it here.',
                      textAlign: TextAlign.center,
                      style: BBTextResponsive.bodyMedium(
                        context,
                        color: BBColors.textMuted(context),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(BBColors.padM),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.62,
                crossAxisSpacing: BBColors.padM,
                mainAxisSpacing: BBColors.padM,
              ),
              itemCount: products.length,
              itemBuilder: (context, i) =>
                  ShopProductCard(product: products[i]),
            ),
    );
  }
}
