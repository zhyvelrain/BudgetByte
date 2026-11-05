import 'package:flutter/material.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../services/component_data_service.dart';
import '../../models/app_models.dart';
import '../product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final featuredProducts = ComponentDataService.getFeatured();
    final onSaleProducts = ComponentDataService.getOnSale();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding =
        screenWidth < BBColors.bpMobile ? BBColors.padM : BBColors.padXL;
    final heroHeight = screenWidth < BBColors.bpMobile ? 245.0 : 220.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar / Hero Section
          SliverAppBar(
            expandedHeight: heroHeight,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: Container(
                decoration: BoxDecoration(
                  gradient: isDark ? BrandAccents.darkSurfaceGradient : BrandAccents.lightSurfaceGradient,
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      top: -50,
                      right: -30,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              BBColors.accentBlue.withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      left: -50,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              BBColors.accentTeal.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Text(
                              'Build Your Dream Setup',
                              style: BBTextResponsive.displayLarge(context, size: 28, weight: FontWeight.w700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: BBColors.padS),
                            Text(
                              'Curated PC peripherals for enthusiasts. Shop, compare, and build.',
                              style: BBTextResponsive.bodyLarge(
                                context,
                                color: isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: BBColors.padL),
                            // Search bar hint
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: BBColors.padL,
                                vertical: BBColors.padM,
                              ),
                              decoration: BoxDecoration(
                                color: (isDark ? BBColors.nightSurface : BBColors.daySurface).withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(BBColors.radiusLg),
                                border: Border.all(
                                  color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    size: 20,
                                    color: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
                                  ),
                                  const SizedBox(width: BBColors.padM),
                                  Text(
                                    'Search keyboards, mice, monitors...',
                                    style: BBTextResponsive.bodyMedium(
                                      context,
                                      color: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                BBColors.padXL,
                horizontalPadding,
                BBColors.padM,
              ),
              child: _CategoriesSection(),
            ),
          ),

          // Featured Products
          if (featuredProducts.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _SectionHeader(
                  title: 'Featured Picks',
                  subtitle: 'Hand-selected by our experts',
                  actionText: 'View All',
                  onAction: () {},
                ),
              ),
            ),

          if (featuredProducts.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                BBColors.padXL,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: BBColors.padM,
                  mainAxisSpacing: BBColors.padM,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = featuredProducts[index];
                    return _buildProductCard(context, product);
                  },
                  childCount: featuredProducts.length > 4 ? 4 : featuredProducts.length,
                ),
              ),
            ),

          // On Sale
          if (onSaleProducts.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _SectionHeader(
                  title: 'On Sale',
                  subtitle: 'Limited time discounts',
                  actionText: 'View All',
                  onAction: () {},
                ),
              ),
            ),

          if (onSaleProducts.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                BBColors.padXL,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: BBColors.padM,
                  mainAxisSpacing: BBColors.padM,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = onSaleProducts[index];
                    return _buildProductCard(context, product);
                  },
                  childCount: onSaleProducts.length > 4 ? 4 : onSaleProducts.length,
                ),
              ),
            ),

          // Categories Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _SectionHeader(
                title: 'Shop by Category',
                subtitle: 'Explore all component types',
                actionText: '',
                onAction: () {},
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              BBColors.padXL,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 1,
                crossAxisSpacing: BBColors.padM,
                mainAxisSpacing: BBColors.padM,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = ComponentCategory.values[index];
                  return _CategoryCard(category: category);
                },
                childCount: ComponentCategory.values.length,
              ),
            ),
          ),

          // Features
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _SectionHeader(
                title: 'Why ByteBudget?',
                subtitle: 'Built for PC enthusiasts',
                actionText: '',
                onAction: () {},
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              BBColors.padXXL,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _FeatureRow(
                  icon: Icons.verified_rounded,
                  title: 'Verified Quality',
                  subtitle: 'Every component tested and verified',
                  color: BBColors.accentBlue,
                ),
                const SizedBox(height: BBColors.padM),
                _FeatureRow(
                  icon: Icons.compare_arrows_rounded,
                  title: 'Price Comparison',
                  subtitle: 'Track prices across retailers',
                  color: BBColors.catMonitor,
                ),
                const SizedBox(height: BBColors.padM),
                _FeatureRow(
                  icon: Icons.build_rounded,
                  title: 'PC Builder',
                  subtitle: 'Create custom builds with compatibility check',
                  color: BBColors.catMouse,
                ),
                const SizedBox(height: BBColors.padM),
                _FeatureRow(
                  icon: Icons.local_shipping_rounded,
                  title: 'Fast Shipping',
                  subtitle: 'Free shipping on orders over \$100',
                  color: BBColors.accentOrange,
                ),
              ]),
            ),
          ),

        ], // end of slivers list
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Component product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(component: product),
        ),
      ),
      child: ProductCard(
        name: product.name,
        brand: product.brand,
        price: product.price,
        originalPrice: product.originalPrice,
        discountLabel: product.discountLabel,
        imageUrl: product.images.isNotEmpty ? product.images.first : 'assets/images/placeholder.jpg',
        rating: product.rating,
        reviewCount: product.reviewCount,
        categoryColor: product.category.color,
        onFavorite: () {},
        isFavorite: false,
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Categories',
              style: BBTextResponsive.headlineLarge(context, weight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: BBTextResponsive.labelMedium(context, color: BBColors.accentBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: BBColors.padM),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ComponentCategory.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: BBColors.padM),
            itemBuilder: (context, index) {
              final category = ComponentCategory.values[index];
              return _CategoryChip(category: category);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final ComponentCategory category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productCount = ComponentDataService.getByCategory(category).length;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(BBColors.padM),
        decoration: BoxDecoration(
          color: isDark ? BBColors.nightSurface : BBColors.daySurface,
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
          border: Border.all(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
              ),
              child: Icon(category.icon, size: 22, color: category.color),
            ),
            const SizedBox(height: BBColors.padS),
            Text(
              category.label,
              style: BBTextResponsive.labelMedium(context, weight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              '$productCount items',
              style: BBTextResponsive.caption(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ComponentCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final productCount = ComponentDataService.getByCategory(category).length;

    return GestureDetector(
      onTap: () {},
      child: BrandCard(
        gradient: LinearGradient(
          colors: [
            category.color.withValues(alpha: 0.2),
            category.color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        padding: const EdgeInsets.all(BBColors.padM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
              ),
              child: Icon(category.icon, size: 26, color: category.color),
            ),
            const SizedBox(height: BBColors.padM),
            Text(
              category.label,
              style: BBTextResponsive.labelLarge(context, weight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '$productCount products',
              style: BBTextResponsive.caption(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BBColors.padM),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: BBTextResponsive.headlineLarge(context, weight: FontWeight.w600)),
                Text(subtitle, style: BBTextResponsive.caption(context)),
              ],
            ),
          ),
          if (actionText.isNotEmpty)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText,
                style: BBTextResponsive.labelMedium(context, color: BBColors.accentBlue, weight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padL),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(BBColors.radiusMd),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: BBColors.padL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: BBTextResponsive.bodySmall(context, color: BBColors.textMuted(context))),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
          ),
        ],
      ),
    );
  }
}
