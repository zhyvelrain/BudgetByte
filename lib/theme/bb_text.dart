import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bb_colors.dart';

/// Text styles using Google Fonts (Space Grotesk for display, Work Sans for body)
/// Inspired by ProduceAIQ's AppText
class BBText {
  BBText._();

  // Display styles (Space Grotesk - tech/modern feel)
  static TextStyle displayLarge({
    double size = 32,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w700,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.05,
        letterSpacing: -0.5,
      );

  static TextStyle displayMedium({
    double size = 24,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w600,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.1,
        letterSpacing: -0.3,
      );

  static TextStyle displaySmall({
    double size = 20,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w600,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.15,
      );

  // Headline styles
  static TextStyle headlineLarge({
    double size = 18,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w600,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.3,
      );

  static TextStyle headlineMedium({
    double size = 16,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w600,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.35,
      );

  static TextStyle headlineSmall({
    double size = 14,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w600,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.4,
      );

  // Body styles
  static TextStyle bodyLarge({
    double size = 16,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.5,
      );

  static TextStyle bodyMedium({
    double size = 14,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.5,
      );

  static TextStyle bodySmall({
    double size = 12,
    Color? color,
    FontWeight? weight,
    double? height,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
        color: color ?? BBColors.nightTextPrimary,
        height: height ?? 1.4,
      );

  // Button styles
  static TextStyle button({
    double size = 15,
    Color? color,
    FontWeight? weight,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w600,
        color: color ?? Colors.white,
        letterSpacing: 0.2,
      );

  // Label styles
  static TextStyle labelLarge({
    double size = 14,
    Color? color,
    FontWeight? weight,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? BBColors.nightTextPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium({
    double size = 12,
    Color? color,
    FontWeight? weight,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? BBColors.nightTextPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle labelSmall({
    double size = 11,
    Color? color,
    FontWeight? weight,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? BBColors.nightTextPrimary,
        letterSpacing: 0.3,
      );

  // Caption
  static TextStyle caption({
    double size = 11,
    Color? color,
    FontWeight? weight,
  }) =>
      GoogleFonts.workSans(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
        color: color ?? BBColors.nightTextMuted,
        height: 1.3,
      );

  // Price style
  static TextStyle price({
    double size = 20,
    Color? color,
    FontWeight? weight,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w700,
        color: color ?? BBColors.nightTextPrimary,
        height: 1.1,
      );

  // Mono for specs/numbers
  static TextStyle mono({
    double size = 13,
    Color? color,
    FontWeight? weight,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? BBColors.nightTextSecondary,
        height: 1.4,
      );
}

/// Responsive text style helpers that resolve colors from context
class BBTextResponsive {
  static TextStyle displayLarge(BuildContext context,
      {double size = 32, Color? color, FontWeight? weight}) =>
      BBText.displayLarge(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle displayMedium(BuildContext context,
      {double size = 24, Color? color, FontWeight? weight}) =>
      BBText.displayMedium(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle displaySmall(BuildContext context,
      {double size = 20, Color? color, FontWeight? weight}) =>
      BBText.displaySmall(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle headlineLarge(BuildContext context,
      {double size = 18, Color? color, FontWeight? weight}) =>
      BBText.headlineLarge(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle headlineMedium(BuildContext context,
      {double size = 16, Color? color, FontWeight? weight}) =>
      BBText.headlineMedium(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle headlineSmall(BuildContext context,
      {double size = 14, Color? color, FontWeight? weight}) =>
      BBText.headlineSmall(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle titleLarge(BuildContext context,
      {double size = 22, Color? color, FontWeight? weight}) =>
      BBText.displaySmall(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle titleMedium(BuildContext context,
      {double size = 16, Color? color, FontWeight? weight}) =>
      BBText.headlineMedium(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle titleSmall(BuildContext context,
      {double size = 14, Color? color, FontWeight? weight}) =>
      BBText.headlineSmall(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle bodyLarge(BuildContext context,
      {double size = 16, Color? color, FontWeight? weight}) =>
      BBText.bodyLarge(
        size: size,
        color: color ?? BBColors.textBody(context),
        weight: weight,
      );

  static TextStyle bodyMedium(BuildContext context,
      {double size = 14, Color? color, FontWeight? weight}) =>
      BBText.bodyMedium(
        size: size,
        color: color ?? BBColors.textBody(context),
        weight: weight,
      );

  static TextStyle bodySmall(BuildContext context,
      {double size = 12, Color? color, FontWeight? weight}) =>
      BBText.bodySmall(
        size: size,
        color: color ?? BBColors.textMuted(context),
        weight: weight,
      );

  static TextStyle button(BuildContext context,
      {double size = 15, Color? color}) =>
      BBText.button(size: size, color: color ?? BBColors.textOnAccent(context));

  static TextStyle labelLarge(BuildContext context,
      {double size = 14, Color? color, FontWeight? weight}) =>
      BBText.labelLarge(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle labelMedium(BuildContext context,
      {double size = 12, Color? color, FontWeight? weight}) =>
      BBText.labelMedium(
        size: size,
        color: color ?? BBColors.textSecondary(context),
        weight: weight,
      );

  static TextStyle labelSmall(BuildContext context,
      {double size = 11, Color? color, FontWeight? weight}) =>
      BBText.labelSmall(
        size: size,
        color: color ?? BBColors.textMuted(context),
        weight: weight,
      );

  static TextStyle caption(BuildContext context,
      {double size = 11, Color? color, FontWeight? weight}) =>
      BBText.caption(
        size: size,
        color: color ?? BBColors.textMuted(context),
        weight: weight,
      );

  static TextStyle price(BuildContext context,
      {double size = 20, Color? color, FontWeight? weight}) =>
      BBText.price(
        size: size,
        color: color ?? BBColors.textPrimary(context),
        weight: weight,
      );

  static TextStyle mono(BuildContext context,
      {double size = 13, Color? color, FontWeight? weight}) =>
      BBText.mono(
        size: size,
        color: color ?? BBColors.textSecondary(context),
        weight: weight,
      );
}