import 'package:flutter/material.dart';

import '../theme/bb_colors.dart';
import '../theme/bb_text.dart';

/// Variant for BrandCard styling
enum BrandCardVariant { defaultCard, elevated, gradient }

/// Brand card widget with consistent styling
class BrandCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool showBorder;
  final BrandCardVariant variant;

  const BrandCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.showBorder = true,
    this.variant = BrandCardVariant.defaultCard,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveColor =
        color ?? (isDark ? BBColors.nightSurface : BBColors.daySurface);
    final effectiveBorder =
        border ??
        (showBorder
            ? Border.all(
                color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
                width: 1,
              )
            : null);
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(BBColors.radiusLg);
    final effectiveElevation = elevation ?? 0;

    BoxShadow? shadow;
    if (effectiveElevation > 0) {
      shadow = BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.08),
        blurRadius: effectiveElevation,
        offset: Offset(0, effectiveElevation / 2),
      );
    }

    // Apply variant-specific styling
    Gradient? variantGradient;
    List<BoxShadow>? variantShadows;

    switch (variant) {
      case BrandCardVariant.elevated:
        variantShadows = [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ];
        break;
      case BrandCardVariant.gradient:
        variantGradient = BrandAccents.electricGradient;
        variantShadows = [
          BoxShadow(
            color: BrandAccents.electricBlue.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ];
        break;
      case BrandCardVariant.defaultCard:
        break;
    }

    final card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(BBColors.padL),
      decoration: BoxDecoration(
        color: variantGradient == null && gradient == null
            ? effectiveColor
            : null,
        gradient: gradient ?? variantGradient,
        borderRadius: effectiveRadius,
        border: effectiveBorder,
        boxShadow:
            variantShadows ?? (effectiveElevation > 0 ? [shadow!] : null),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: effectiveRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          splashColor: BBColors.accentBlue.withValues(alpha: 0.1),
          highlightColor: BBColors.accentBlue.withValues(alpha: 0.05),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Product card for grid/list views
class ProductCard extends StatelessWidget {
  final String name;
  final String brand;
  final double price;
  final double? originalPrice;
  final String? discountLabel;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final Color? categoryColor;

  const ProductCard({
    super.key,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    this.discountLabel,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.categoryColor,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveCategoryColor = categoryColor ?? BBColors.accentBlue;

    return BrandCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with favorite button
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? BBColors.nightSurfaceAlt
                        : BBColors.daySurfaceAlt,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(BBColors.radiusLg),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(BBColors.radiusLg),
                    ),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, _, _) => Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: isDark
                              ? BBColors.nightTextMuted
                              : BBColors.dayTextMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Discount badge
              if (hasDiscount || discountLabel != null)
                Positioned(
                  top: BBColors.padS,
                  left: BBColors.padS,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BBColors.padS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: BBColors.danger,
                      borderRadius: BorderRadius.circular(BBColors.radiusFull),
                    ),
                    child: Text(
                      discountLabel ??
                          '-${((originalPrice! - price) / originalPrice! * 100).round()}%',
                      style: BBText.labelSmall(
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              // Favorite button
              Positioned(
                top: BBColors.padS,
                right: BBColors.padS,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(BBColors.radiusFull),
                  child: InkWell(
                    onTap: onFavorite,
                    borderRadius: BorderRadius.circular(BBColors.radiusFull),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? BBColors.nightBg : BBColors.white)
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(
                          BBColors.radiusFull,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: isFavorite
                            ? BBColors.danger
                            : (isDark
                                  ? BBColors.nightTextSecondary
                                  : BBColors.dayTextSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(BBColors.padM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                Text(
                  brand.toUpperCase(),
                  style: BBTextResponsive.labelSmall(
                    context,
                    color: effectiveCategoryColor,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // Name
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: BBTextResponsive.bodyMedium(
                    context,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: BBColors.padS),
                // Rating
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: BBColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: BBTextResponsive.labelSmall(
                        context,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviewCount)',
                      style: BBTextResponsive.labelSmall(
                        context,
                        color: BBColors.textMuted(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: BBColors.padS),
                // Price
                Row(
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: BBTextResponsive.price(
                        context,
                        size: 18,
                        weight: FontWeight.w700,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: BBColors.padS),
                      Expanded(
                        child: Text(
                          '\$${originalPrice!.toStringAsFixed(2)}',
                          style: BBTextResponsive.bodySmall(
                            context,
                            color: BBColors.textMuted(context),
                          ).copyWith(decoration: TextDecoration.lineThrough),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Feature card for home screen sections
class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return BrandCard(
      onTap: onTap,
      gradient: gradient,
      padding: const EdgeInsets.all(BBColors.padL),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(BBColors.radiusMd),
            ),
            child: Icon(icon, size: 26, color: Colors.white),
          ),
          const SizedBox(width: BBColors.padL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: BBTextResponsive.headlineSmall(
                    context,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: BBTextResponsive.bodySmall(
                    context,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          if (trailing case Widget w) w,
          if (onTap != null && trailing == null)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
        ],
      ),
    );
  }
}

/// Stats card for dashboard
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool isPositiveTrend;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(BBColors.radiusMd),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isPositiveTrend ? BBColors.success : BBColors.danger)
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(BBColors.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 10,
                        color: isPositiveTrend
                            ? BBColors.success
                            : BBColors.danger,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: BBText.labelSmall(
                          color: isPositiveTrend
                              ? BBColors.success
                              : BBColors.danger,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: BBColors.padL),
          Text(
            value,
            style: BBTextResponsive.displayMedium(
              context,
              size: 24,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: BBTextResponsive.labelMedium(
              context,
              color: BBColors.textMuted(context),
            ),
          ),
        ],
      ),
    );
  }
}
