import 'package:flutter/material.dart';
import '../theme/bb_colors.dart';
import '../theme/bb_text.dart';

enum BrandButtonVariant { primary, secondary, outline, ghost }
enum BrandButtonSize { small, medium, large }
enum IconPosition { leading, trailing }

class BrandButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final BrandButtonVariant variant;
  final BorderSide? borderSide;
  final bool fullWidth;

  const BrandButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.iconPosition = IconPosition.leading,
    this.width,
    this.height = 52,
    this.borderRadius = BBColors.radiusMd,
    this.padding,
    this.isLoading = false,
    this.variant = BrandButtonVariant.primary,
    this.borderSide,
    this.fullWidth = false,
  });

  // Factory constructors for common variants
  factory BrandButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    bool fullWidth = false,
  }) => BrandButton(
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        variant: BrandButtonVariant.primary,
        fullWidth: fullWidth,
      );

  factory BrandButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    bool fullWidth = false,
  }) => BrandButton(
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        variant: BrandButtonVariant.secondary,
        fullWidth: fullWidth,
      );

  factory BrandButton.outline({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    Color? foregroundColor,
    bool fullWidth = false,
  }) => BrandButton(
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        variant: BrandButtonVariant.outline,
        foregroundColor: foregroundColor,
        fullWidth: fullWidth,
      );

  factory BrandButton.ghost({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    bool fullWidth = false,
  }) => BrandButton(
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        variant: BrandButtonVariant.ghost,
        fullWidth: fullWidth,
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveGradient = gradient ?? BrandAccents.electricGradient;
    final effectiveBgColor = backgroundColor ?? (isDark ? BBColors.nightSurface : BBColors.daySurface);
    final effectiveFgColor = foregroundColor ?? Colors.white;
    final effectiveBorderSide = borderSide ?? BorderSide(
          color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
          width: 1.5,
        );

    final buttonChild = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveFgColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && iconPosition == IconPosition.leading) ...[
                Icon(icon, size: 20, color: effectiveFgColor),
                const SizedBox(width: BBColors.padS),
              ],
              Flexible(
                child: Text(
                  text,
                  style: BBText.button(color: effectiveFgColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null && iconPosition == IconPosition.trailing) ...[
                const SizedBox(width: BBColors.padS),
                Icon(icon, size: 20, color: effectiveFgColor),
              ],
            ],
          );

    switch (variant) {
      case BrandButtonVariant.outline:
              return SizedBox(
                width: fullWidth ? double.infinity : width,
                height: height,
                child: OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: effectiveFgColor,
                    side: BorderSide(
                      color: gradient != null ? effectiveGradient.colors.first : effectiveBorderSide.color,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    padding: padding ?? const EdgeInsets.symmetric(horizontal: BBColors.padXL, vertical: BBColors.padM),
                    backgroundColor: Colors.transparent,
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return (gradient?.colors.first ?? BBColors.accentBlue).withValues(alpha: 0.1);
                      }
                      if (states.contains(WidgetState.hovered)) {
                        return (gradient?.colors.first ?? BBColors.accentBlue).withValues(alpha: 0.05);
                      }
                      return Colors.transparent;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted;
                      }
                      return effectiveFgColor;
                    }),
                  ),
                  child: buttonChild,
                ),
              );
      case BrandButtonVariant.ghost:
        return SizedBox(
          width: fullWidth ? double.infinity : width,
          height: height,
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: effectiveFgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: BBColors.padXL, vertical: BBColors.padM),
            ).copyWith(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted;
                }
                return effectiveFgColor;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return effectiveFgColor.withValues(alpha: 0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return effectiveFgColor.withValues(alpha: 0.05);
                }
                return Colors.transparent;
              }),
            ),
            child: buttonChild,
          ),
        );
      case BrandButtonVariant.secondary:
              return SizedBox(
                width: fullWidth ? double.infinity : width,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: isDark ? BBColors.cardGradientDark : BBColors.cardGradientLight,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: isDark ? BBColors.nightBorderStrong : BBColors.dayBorderStrong,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                            ? BBColors.accentBlue.withValues(alpha: 0.1)
                            : BBColors.accentBlue.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: InkWell(
                      onTap: onPressed,
                      borderRadius: BorderRadius.circular(borderRadius),
                      splashColor: BBColors.accentBlue.withValues(alpha: 0.15),
                      highlightColor: BBColors.accentBlue.withValues(alpha: 0.05),
                      child: Container(
                        padding: padding ?? const EdgeInsets.symmetric(horizontal: BBColors.padXL, vertical: BBColors.padM),
                        alignment: Alignment.center,
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            color: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
                          ),
                          child: buttonChild,
                        ),
                      ),
                    ),
                  ),
                ),
              );
      case BrandButtonVariant.primary:
              final primaryGradient = gradient ?? BrandAccents.electricGradient;
              return SizedBox(
                width: fullWidth ? double.infinity : width,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: primaryGradient,
                    color: gradient == null ? effectiveBgColor : null,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: primaryGradient.colors.isNotEmpty
                        ? [
                            BoxShadow(
                              color: primaryGradient.colors.first.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: InkWell(
                      onTap: onPressed,
                      borderRadius: BorderRadius.circular(borderRadius),
                      splashColor: effectiveFgColor.withValues(alpha: 0.15),
                      highlightColor: effectiveFgColor.withValues(alpha: 0.05),
                      child: Container(
                        padding: padding ?? const EdgeInsets.symmetric(horizontal: BBColors.padXL, vertical: BBColors.padM),
                        alignment: Alignment.center,
                        child: buttonChild,
                ),
              ),
            ),
          ),
        );
    }
  }
}

/// Icon button variant
class BrandIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final String? tooltip;
  final Gradient? gradient;

  const BrandIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 44,
    this.iconSize = 22,
    this.borderRadius = BBColors.radiusMd,
    this.tooltip,
    this.gradient,
  });

  @override
    Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final effectiveColor = color ?? (isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary);
      final effectiveBgColor = backgroundColor ?? (isDark ? BBColors.nightSurfaceAlt : BBColors.daySurfaceAlt);

      final button = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: effectiveColor.withValues(alpha: 0.1),
        highlightColor: effectiveColor.withValues(alpha: 0.05),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? effectiveBgColor : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: gradient == null
                ? Border.all(
                    color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
                    width: 1,
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: gradient != null ? Colors.white : effectiveColor,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }
    return button;
  }
}