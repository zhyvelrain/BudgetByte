import 'package:flutter/material.dart';

/// ByteBudget color palette - Blue & Cream theme
/// Light cream background with soft blue accents
class BBColors {
  BBColors._();

  // ── Light Mode (Primary - Cream Base) ────────────────────────────────
  static const dayBg = Color(0xFFFFFDF5);           // Warm cream
  static const daySurface = Color(0xFFFFFFFF);      // Pure white cards
  static const daySurfaceAlt = Color(0xFFFFF5E6);   // Light cream alt
  static const daySurfaceHigh = Color(0xFFFFECD9);  // Cream highlight
  static const daySurfaceElevated = Color(0xFFFFFFFF);
  static const dayDivider = Color(0xFFFFE0C2);      // Soft cream divider
  static const dayBorder = Color(0xFFFFE0C2);
  static const dayBorderStrong = Color(0xFFFFD4A3);
  static const dayTextPrimary = Color(0xFF2D2D2D);  // Dark charcoal
  static const dayTextSecondary = Color(0xFF5A5A5A); // Medium gray
  static const dayTextMuted = Color(0xFF999999);    // Muted gray
  static const dayTextBody = Color(0xFF3D3D3D);
  static const dayMuted = Color(0xFF999999);
  static const dayMutedStrong = Color(0xFFBBBBBB);
  static const dayOnBg = Color(0xFF2D2D2D);
  static const dayOnSurface = Color(0xFF3D3D3D);
  static const dayOnSurfaceVariant = Color(0xFF777777);
  static const dayScrim = Color(0xCC000000);

  // ── Dark Mode (Secondary - Deep Blue Base) ──────────────────────────
  static const nightBg = Color(0xFF0D1B2A);
  static const nightSurface = Color(0xFF1B2A4A);
  static const nightSurfaceAlt = Color(0xFF1F3A5F);
  static const nightSurfaceHigh = Color(0xFF24406E);
  static const nightSurfaceElevated = Color(0xFF2A4A7A);
  static const nightDivider = Color(0xFF3A5A8C);
  static const nightBorder = Color(0xFF3A5A8C);
  static const nightBorderStrong = Color(0xFF4A6FA5);
  static const nightTextPrimary = Color(0xFFF0F4F8);
  static const nightTextSecondary = Color(0xFFB8C5D6);
  static const nightTextMuted = Color(0xFF8B9DC3);
  static const nightTextBody = Color(0xFFD0D8E8);
  static const nightMuted = Color(0xFF8B9DC3);
  static const nightMutedStrong = Color(0xFF6B8DB8);
  static const nightOnBg = Color(0xFFF0F4F8);
  static const nightOnSurface = Color(0xFFE0E8F0);
  static const nightOnSurfaceVariant = Color(0xFF9BB4D4);
  static const nightScrim = Color(0xCC000000);

  // ── Brand Accent - Soft Blue (pairs with cream) ──────────────────────
  static const accentBlue = Color(0xFF3A8FD6);      // Primary blue - softer, pairs with cream
  static const accentBlueDim = Color(0xFF2E7BB8);
  static const accentBlueSoft = Color(0xFFE8F4FD);  // Very light blue for backgrounds
  static const accentBlueWash = Color(0xFFD1E9F8);  // Light blue wash
  static const accentBlueDeep = Color(0xFF1E5F9A);
  static const accentBlueContainer = Color(0xFF153D6B);
  static const accentBlueDark = Color(0xFF256FA0);
  static const accentBlueLight = Color(0xFF5AB3E8);

  // Accent soft for selected tile (no context needed)
  static const nightAccentSoft = accentBlueWash;
  static const dayAccentSoft = accentBlueSoft;

  // ── Accent Variants ───────────────────────────────────────────────
  static const accentTeal = Color(0xFF2AA9A1);      // Teal for variety
  static const accentTealSoft = Color(0xFFE0F7F6);
  static const accentWarm = Color(0xFFE8A838);      // Warm gold for highlights
  static const accentWarmSoft = Color(0xFFFFF3E0);
  static const accentGreen = Color(0xFF2E7D32);
  static const accentGreenSoft = Color(0xFFE8F5E9);
  static const accentRed = Color(0xFFC62828);
  static const accentRedSoft = Color(0xFFFDEDEC);

  // Legacy aliases for backwards compatibility
  static const accentPurple = accentBlue;
  static const accentPurpleSoft = accentBlueSoft;
  static const accentOrange = accentWarm;
  static const accentOrangeSoft = accentWarmSoft;
  static const electricBlue = accentBlue;

  // ── Category Colors (Blue family variations) ────────────────────────
  static const catKeyboard = Color(0xFF3A8FD6);     // Blue
  static const catMouse = Color(0xFF5A9FE8);        // Lighter blue
  static const catMonitor = Color(0xFF2AA9A1);      // Teal
  static const catAudio = Color(0xFF4AA3D6);        // Medium blue
  static const catCamera = Color(0xFF3A7FD6);       // Deep blue
  static const catAccessory = Color(0xFF6AB0E8);    // Pale blue

  // ── Status Colors ─────────────────────────────────────────────────
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFE8A838);
  static const danger = Color(0xFFC62828);
  static const info = Color(0xFF3A8FD6);
  static const error = Color(0xFFC62828);

  // ── Neutral ───────────────────────────────────────────────────────
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // ── Spacing Scale ─────────────────────────────────────────────────
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space18 = 18.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space28 = 28.0;
  static const double space32 = 32.0;
  static const double space36 = 36.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;

  // Semantic spacing aliases
  static const double padXS = space4;
  static const double padS = space8;
  static const double padM = space16;
  static const double padL = space24;
  static const double padXL = space32;
  static const double padXXL = space48;

  // ── Border Radius ─────────────────────────────────────────────────
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusFull = 9999.0;

  // Aliases for common naming patterns
  static const double radiusSm = radiusS;
  static const double radiusMd = radiusM;
  static const double radiusLg = radiusL;
  static const double radiusXl = radiusXL;

  // ── Elevation / Shadows ───────────────────────────────────────────
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 3.0;
  static const double elevation3 = 6.0;
  static const double elevation4 = 10.0;
  static const double elevation5 = 15.0;

  // Aliases
  static const double elevationSm = elevation2;
  static const double elevationMd = elevation3;
  static const double elevationLg = elevation4;
  static const double elevationXl = elevation5;

  static List<BoxShadow> shadowLevel(int level, {bool isDark = false}) {
    final color = isDark ? black.withValues(alpha: 0.3) : black.withValues(alpha: 0.08);
    final blur = [0.0, 2.0, 6.0, 12.0, 20.0, 30.0][level.clamp(0, 5)];
    final offset = [Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(0, 4), Offset(0, 8), Offset(0, 12)][level.clamp(0, 5)];
    return [BoxShadow(color: color, blurRadius: blur, offset: offset)];
  }

  // ── Animation Durations ───────────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  static const Duration durationPage = Duration(milliseconds: 300);

  // Aliases
  static const Duration animFast = durationFast;
  static const Duration animNormal = durationNormal;
  static const Duration animSlow = durationSlow;

  // ── Breakpoints ───────────────────────────────────────────────────
  static const double bpMobile = 480;
  static const double bpTablet = 768;
  static const double bpDesktop = 1024;
  static const double bpWide = 1440;

  // ── Helpers ───────────────────────────────────────────────────────
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightTextPrimary : dayTextPrimary;
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightTextSecondary : dayTextSecondary;
  static Color textMuted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightTextMuted : dayTextMuted;
  static Color textBody(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightTextBody : dayTextBody;
  static Color textOnAccent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightTextPrimary : dayTextPrimary;
  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightSurface : daySurface;
  static Color surfaceAlt(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightSurfaceAlt : daySurfaceAlt;
  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightDivider : dayDivider;
  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightBorder : dayBorder;
  static Color bg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightBg : dayBg;

  // Get accent color with opacity
  static Color electricBlueAt(double opacity) => accentBlue.withValues(alpha: opacity);
}

// ── Brand Gradients ──────────────────────────────────────────────────
class BrandAccents {
  static const Color electricBlue = BBColors.accentBlue;
  static Color electricBlueAt(double opacity) => electricBlue.withValues(alpha: opacity);
  static const electricGradient = LinearGradient(
    colors: [BBColors.accentBlue, BBColors.accentTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const lightSurfaceGradient = LinearGradient(
    colors: [BBColors.daySurface, BBColors.daySurfaceAlt],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const darkSurfaceGradient = LinearGradient(
    colors: [BBColors.nightSurface, BBColors.nightSurfaceAlt],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const cardGradient = LinearGradient(
    colors: [BBColors.white, BBColors.daySurfaceAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const blueCreamGradient = LinearGradient(
    colors: [BBColors.accentBlueSoft, BBColors.daySurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category gradients (blue family)
  static const catKeyboardGradient = LinearGradient(
    colors: [BBColors.catKeyboard, Color(0xFF5AB3E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const catMouseGradient = LinearGradient(
    colors: [BBColors.catMouse, Color(0xFF7AB8F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const catMonitorGradient = LinearGradient(
    colors: [BBColors.catMonitor, Color(0xFF4DD0C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const catAudioGradient = LinearGradient(
    colors: [BBColors.catAudio, Color(0xFF6AB8E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const catCameraGradient = LinearGradient(
    colors: [BBColors.catCamera, Color(0xFF5A9FE8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const catAccessoryGradient = LinearGradient(
    colors: [BBColors.catAccessory, Color(0xFF8AC8F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}