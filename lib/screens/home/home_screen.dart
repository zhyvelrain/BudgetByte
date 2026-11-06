import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shop_provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../services/component_data_service.dart';
import '../../models/app_models.dart';
import '../product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  String _query = '';
  ComponentCategory? _category;
  bool _onSaleOnly = false;
  bool _showAll = false;

  bool get _filtering =>
      _query.isNotEmpty || _category != null || _onSaleOnly || _showAll;

  List<Component> get _results => ComponentDataService.search(_query)
      .where(
        (c) =>
            (_category == null || c.category == _category) &&
            (!_onSaleOnly || c.hasDiscount),
      )
      .toList();

  String get _resultsTitle {
    if (_category != null) return _category!.label;
    if (_onSaleOnly) return 'On Sale';
    if (_query.isNotEmpty) return 'Results for "$_query"';
    return 'All Products';
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _search.clear();
    setState(() {
      _query = '';
      _category = null;
      _onSaleOnly = false;
      _showAll = false;
    });
  }

  void _show({ComponentCategory? category, bool onSale = false}) {
    setState(() {
      _category = category;
      _onSaleOnly = onSale;
      _showAll = true;
    });
    _scroll.animateTo(
      0,
      duration: BBColors.animNormal,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final featuredProducts = ComponentDataService.getFeatured();
    final onSaleProducts = ComponentDataService.getOnSale();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < BBColors.bpMobile
        ? BBColors.padM
        : BBColors.padXL;
    final heroHeight = screenWidth < BBColors.bpMobile ? 245.0 : 220.0;
    final mutedColor = isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted;
    final dividerColor = isDark ? BBColors.nightDivider : BBColors.dayDivider;
    final results = _results;

    Widget grid(List<Component> products) => SliverPadding(
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
          (context, index) => ShopProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );

    Widget header(
      String title,
      String subtitle,
      String action,
      VoidCallback onAction,
    ) => SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: _SectionHeader(
          title: title,
          subtitle: subtitle,
          actionText: action,
          onAction: onAction,
        ),
      ),
    );

    OutlineInputBorder searchBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
          borderSide: BorderSide(color: color, width: width),
        );

    return Scaffold(
      body: CustomScrollView(
        controller: _scroll,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // Hero with search
          SliverAppBar(
            expandedHeight: heroHeight,
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
                  gradient: isDark
                      ? BrandAccents.darkSurfaceGradient
                      : BrandAccents.lightSurfaceGradient,
                ),
                child: Stack(
                  children: [
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
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Text(
                              'Build Your Dream Setup',
                              style: BBTextResponsive.displayLarge(
                                context,
                                size: 28,
                                weight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: BBColors.padS),
                            Text(
                              'Curated PC peripherals for enthusiasts. Shop, compare, and build.',
                              style: BBTextResponsive.bodyLarge(
                                context,
                                color: isDark
                                    ? BBColors.nightTextSecondary
                                    : BBColors.dayTextSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: BBColors.padL),
                            TextField(
                              controller: _search,
                              textInputAction: TextInputAction.search,
                              onChanged: (v) =>
                                  setState(() => _query = v.trim()),
                              style: BBTextResponsive.bodyMedium(context),
                              decoration: InputDecoration(
                                hintText: 'Search keyboards, mice, monitors...',
                                hintStyle: BBTextResponsive.bodyMedium(
                                  context,
                                  color: mutedColor,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                  color: mutedColor,
                                ),
                                suffixIcon: _query.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: 'Clear search',
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          _search.clear();
                                          setState(() => _query = '');
                                        },
                                      ),
                                filled: true,
                                fillColor:
                                    (isDark
                                            ? BBColors.nightSurface
                                            : BBColors.daySurface)
                                        .withValues(alpha: 0.9),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: BBColors.padM,
                                ),
                                border: searchBorder(dividerColor),
                                enabledBorder: searchBorder(dividerColor),
                                focusedBorder: searchBorder(
                                  BBColors.accentBlue,
                                  1.5,
                                ),
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

          // Category filter
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                BBColors.padXL,
                horizontalPadding,
                BBColors.padM,
              ),
              child: _CategoriesSection(
                selected: _category,
                onSelect: (c) => setState(() {
                  _category = _category == c ? null : c;
                  _onSaleOnly = false;
                }),
                onViewAll: () => _show(),
              ),
            ),
          ),

          if (_filtering) ...[
            header(
              _resultsTitle,
              '${results.length} ${results.length == 1 ? 'product' : 'products'}',
              'Clear',
              _clearFilters,
            ),
            if (results.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    BBColors.padXL,
                    horizontalPadding,
                    BBColors.padXXL,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: mutedColor,
                      ),
                      const SizedBox(height: BBColors.padM),
                      Text(
                        'No products match',
                        style: BBTextResponsive.titleMedium(
                          context,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: BBColors.padS),
                      Text(
                        'Try another search term or category.',
                        style: BBTextResponsive.bodyMedium(
                          context,
                          color: mutedColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              grid(results),
          ] else ...[
            if (featuredProducts.isNotEmpty) ...[
              header(
                'Featured Picks',
                'Hand-selected by our experts',
                'View All',
                () => _show(),
              ),
              grid(featuredProducts.take(4).toList()),
            ],
            if (onSaleProducts.isNotEmpty) ...[
              header(
                'On Sale',
                'Limited time discounts',
                'View All',
                () => _show(onSale: true),
              ),
              grid(onSaleProducts.take(4).toList()),
            ],
            header(
              'Shop by Category',
              'Explore all component types',
              '',
              () {},
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = ComponentCategory.values[index];
                  return _CategoryCard(
                    category: category,
                    onTap: () => _show(category: category),
                  );
                }, childCount: ComponentCategory.values.length),
              ),
            ),
            header('Why ByteBudget?', 'Built for PC enthusiasts', '', () {}),
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
                    subtitle:
                        'Free shipping on orders over ${context.money(100)}',
                    color: BBColors.accentOrange,
                  ),
                ]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Product card wired to the shop: opens details, toggles favorite, quick-adds the default variant.
class ShopProductCard extends StatelessWidget {
  final Component product;

  const ShopProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    return ProductCard(
      name: product.name,
      brand: product.brand,
      price: product.price,
      originalPrice: product.originalPrice,
      discountLabel: product.discountLabel,
      imageUrl: product.images.isNotEmpty ? product.images.first : '',
      rating: product.rating,
      reviewCount: product.reviewCount,
      categoryColor: product.category.color,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(component: product),
        ),
      ),
      isFavorite: shop.isFavorite(product.id),
      onFavorite: () => shop.toggleFavorite(product.id),
      onAddToCart: product.isInStock
          ? () => addToCartWithFeedback(context, product)
          : null,
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  final ComponentCategory? selected;
  final ValueChanged<ComponentCategory> onSelect;
  final VoidCallback onViewAll;

  const _CategoriesSection({
    required this.selected,
    required this.onSelect,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Categories',
              style: BBTextResponsive.headlineLarge(
                context,
                weight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'View All',
                style: BBTextResponsive.labelMedium(
                  context,
                  color: BBColors.accentBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: BBColors.padM),
        SizedBox(
          height: 124,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ComponentCategory.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: BBColors.padM),
            itemBuilder: (context, index) {
              final category = ComponentCategory.values[index];
              return _CategoryChip(
                category: category,
                selected: category == selected,
                onTap: () => onSelect(category),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final ComponentCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productCount = ComponentDataService.getByCategory(category).length;
    final radius = BorderRadius.circular(BBColors.radiusLg);

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? category.color.withValues(alpha: 0.12)
            : (isDark ? BBColors.nightSurface : BBColors.daySurface),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected
                ? category.color
                : (isDark ? BBColors.nightDivider : BBColors.dayDivider),
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(BBColors.padM),
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
                  style: BBTextResponsive.labelMedium(
                    context,
                    weight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '$productCount items',
                  style: BBTextResponsive.caption(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ComponentCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final productCount = ComponentDataService.getByCategory(category).length;

    return BrandCard(
      onTap: onTap,
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
            style: BBTextResponsive.labelLarge(
              context,
              weight: FontWeight.w600,
            ),
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
                Text(
                  title,
                  style: BBTextResponsive.headlineLarge(
                    context,
                    weight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(subtitle, style: BBTextResponsive.caption(context)),
              ],
            ),
          ),
          if (actionText.isNotEmpty)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText,
                style: BBTextResponsive.labelMedium(
                  context,
                  color: BBColors.accentBlue,
                  weight: FontWeight.w600,
                ),
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
                Text(
                  title,
                  style: BBTextResponsive.bodyMedium(
                    context,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: BBTextResponsive.bodySmall(
                    context,
                    color: BBColors.textMuted(context),
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
