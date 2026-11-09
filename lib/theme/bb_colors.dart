import 'package:flutter/material.dart';
import '../models/app_models.dart';

/// ByteBudget color palette - Professional Blue & Cream with Gradients
/// Light cream background with soft blue accents, Dark mode with deep blue
class BBColors {
  BBColors._();

  // ── Light Mode (Primary - Cream Base with Subtle Blue) ────────────────────────────────
  static const dayBg = Color(0xFFF8FAFC);           // Very light blue-gray (slate 50)
  static const daySurface = Color(0xFFFFFFFF);      // Pure white cards
  static const daySurfaceAlt = Color(0xFFF1F5F9);   // Slate 100 for alt surfaces
  static const daySurfaceHigh = Color(0xFFE2E8F0);  // Slate 200 for highlights
  static const daySurfaceElevated = Color(0xFFFFFFFF);
  static const dayDivider = Color(0xFFE2E8F0);      // Slate 200
  static const dayBorder = Color(0xFFE2E8F0);
  static const dayBorderStrong = Color(0xFFCBD5E1); // Slate 300
  static const dayTextPrimary = Color(0xFF0F172A);  // Slate 900 - high contrast
  static const dayTextSecondary = Color(0xFF334155); // Slate 700
  static const dayTextMuted = Color(0xFF64748B);    // Slate 500
  static const dayTextBody = Color(0xFF1E293B);     // Slate 800
  static const dayMuted = Color(0xFF94A3B8);        // Slate 400
  static const dayMutedStrong = Color(0xFFCBD5E1);  // Slate 300
  static const dayOnBg = Color(0xFF0F172A);
  static const dayOnSurface = Color(0xFF1E293B);
  static const dayOnSurfaceVariant = Color(0xFF475569); // Slate 600
  static const dayScrim = Color(0xCC000000);

  // ── Dark Mode (Deep Slate/Blue Base) ──────────────────────────
  static const nightBg = Color(0xFF020617);         // Slate 950
  static const nightSurface = Color(0xFF0F172A);    // Slate 900
  static const nightSurfaceAlt = Color(0xFF1E293B); // Slate 800
  static const nightSurfaceHigh = Color(0xFF334155); // Slate 700
  static const nightSurfaceElevated = Color(0xFF1E293B);
  static const nightDivider = Color(0xFF334155);    // Slate 700
  static const nightBorder = Color(0xFF334155);
  static const nightBorderStrong = Color(0xFF475569); // Slate 600
  static const nightTextPrimary = Color(0xFFF8FAFC);  // Slate 50
  static const nightTextSecondary = Color(0xFFE2E8F0); // Slate 200
  static const nightTextMuted = Color(0xFF94A3B8);    // Slate 400
  static const nightTextBody = Color(0xFFCBD5E1);     // Slate 300
  static const nightMuted = Color(0xFF64748B);        // Slate 500
  static const nightMutedStrong = Color(0xFF94A3B8);  // Slate 400
  static const nightOnBg = Color(0xFFF8FAFC);
  static const nightOnSurface = Color(0xFFE2E8F0);
  static const nightOnSurfaceVariant = Color(0xFF94A3B8);
  static const nightScrim = Color(0xCC000000);

  // ── Brand Accent - Professional Blue (works on both light/dark) ──────────────────────
  static const accentBlue = Color(0xFF2563EB);      // Blue 600 - primary
  static const accentBlueDim = Color(0xFF1D4ED8);   // Blue 700
  static const accentBlueSoft = Color(0xFFDBEAFE);  // Blue 50 - light mode backgrounds
  static const accentBlueWash = Color(0xFFBFDBFE);  // Blue 200
  static const accentBlueDeep = Color(0xFF1E40AF);  // Blue 800
  static const accentBlueContainer = Color(0xFF1E3A8A); // Blue 900
  static const accentBlueDark = Color(0xFF172554);  // Blue 950
  static const accentBlueLight = Color(0xFF60A5FA); // Blue 400 - dark mode text

  // Accent soft for selected tile
    static const nightAccentSoft = Color(0xFF1E3A8A); // Blue 900 with opacity
    static const dayAccentSoft = Color(0xFFDBEAFE);   // Blue 50

    // ── Accent Variants ───────────────────────────────────────────────
    static const accentTeal = Color(0xFF0D9488);      // Teal 600
    static const accentTealSoft = Color(0xFFCCFBF1);  // Teal 50
    static const accentWarm = Color(0xFFD97706);      // Amber 600
    static const accentWarmSoft = Color(0xFFFFF8E1);  // Amber 50
    static const accentGreen = Color(0xFF16A34A);     // Green 600
    static const accentGreenSoft = Color(0xFFF0FDF4); // Green 50
    static const accentRed = Color(0xFFDC2626);       // Red 600
    static const accentRedSoft = Color(0xFFFEF2F2);   // Red 50

    // ── Missing Accent Colors (referenced in codebase) ──────────────────
    static const accentOrange = Color(0xFFF97316);      // Orange 500
    static const accentOrangeSoft = Color(0xFFFFF7ED);  // Orange 50
    static const accentPurple = Color(0xFF9333EA);      // Purple 600
    static const accentPurpleSoft = Color(0xFFFAF5FF);  // Purple 50

    // Category accent colors (solid colors for category chips/indicators)
    static const catKeyboard = Color(0xFF2563EB);   // Blue 600
    static const catMouse = Color(0xFF0D9488);      // Teal 600
    static const catMonitor = Color(0xFF7C3AED);    // Violet 600
    static const catAudio = Color(0xFFD97706);      // Amber 600
    static const catCamera = Color(0xFFDC2626);     // Red 600
    static const catAccessory = Color(0xFF0891B2);  // Cyan 600

    // ── Gradient Definitions (Professional) ────────────────────────────
  // Primary brand gradient - blue to indigo
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF4F46E5)], // Blue 600 -> Indigo 600
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Surface gradient for cards (light mode)
  static const LinearGradient cardGradientLight = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Surface gradient for cards (dark mode)
  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Hero/background gradient
  static const LinearGradient heroGradientLight = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFE0E7FF)], // Slate 50 -> Indigo 100
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient heroGradientDark = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)], // Slate 900 -> Indigo 950
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Category gradients (for category cards)
  static const LinearGradient catKeyboardGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)], // Blue 600 -> 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient catMouseGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF14B8A6)], // Teal 600 -> 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient catMonitorGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)], // Violet 600 -> 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient catAudioGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)], // Amber 600 -> 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient catCameraGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFEF4444)], // Red 600 -> 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient catAccessoryGradient = LinearGradient(
    colors: [Color(0xFF0891B2), Color(0xFF06B6D4)], // Cyan 600 -> 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Status Colors ─────────────────────────────────────────────────
  static const success = Color(0xFF16A34A);     // Green 600
  static const warning = Color(0xFFD97706);     // Amber 600
  static const danger = Color(0xFFDC2626);      // Red 600
  static const info = Color(0xFF2563EB);        // Blue 600
  static const error = Color(0xFFDC2626);       // Red 600

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
  
  // Primary brand gradient - blue to indigo
  static const electricGradient = BBColors.primaryGradient;

  // Surface gradients
  static const lightSurfaceGradient = BBColors.cardGradientLight;
  static const darkSurfaceGradient = BBColors.cardGradientDark;

  // Hero gradients
  static const heroGradientLight = BBColors.heroGradientLight;
  static const heroGradientDark = BBColors.heroGradientDark;

  // Category gradients
    static const catKeyboardGradient = BBColors.catKeyboardGradient;
    static const catMouseGradient = BBColors.catMouseGradient;
    static const catMonitorGradient = BBColors.catMonitorGradient;
    static const catAudioGradient = BBColors.catAudioGradient;
    static const catCameraGradient = BBColors.catCameraGradient;
    static const catAccessoryGradient = BBColors.catAccessoryGradient;

    static Gradient categoryGradient(ComponentCategory category) {
      switch (category) {
        case ComponentCategory.keyboard:
          return catKeyboardGradient;
        case ComponentCategory.mouse:
          return catMouseGradient;
        case ComponentCategory.monitor:
          return catMonitorGradient;
        case ComponentCategory.audio:
          return catAudioGradient;
        case ComponentCategory.camera:
          return catCameraGradient;
        case ComponentCategory.accessory:
          return catAccessoryGradient;
      }
    }
  }