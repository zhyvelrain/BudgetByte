import 'package:flutter/material.dart';

/// ByteBudget palette: warm paper + graphite neutrals, one burnt-orange accent.
/// Token names are historical (e.g. `accentBlue` is the primary accent).
class BBColors {
  BBColors._();

  // ── Light mode: warm paper ───────────────────────────────────────────
  static const dayBg = Color(0xFFF6F4EF);
  static const daySurface = Color(0xFFFFFFFF);
  static const daySurfaceAlt = Color(0xFFEFECE5);
  static const daySurfaceHigh = Color(0xFFE7E3DB);
  static const daySurfaceElevated = Color(0xFFFFFFFF);
  static const dayDivider = Color(0xFFE0DBD1);
  static const dayBorder = Color(0xFFE0DBD1);
  static const dayBorderStrong = Color(0xFFCFC8BB);
  static const dayTextPrimary = Color(0xFF1B1A17);
  static const dayTextSecondary = Color(0xFF4D4A44);
  static const dayTextMuted = Color(0xFF66625A); // 5.3:1 on dayBg
  static const dayTextBody = Color(0xFF2E2C28);
  static const dayMuted = Color(0xFF66625A);
  static const dayMutedStrong = Color(0xFF8C877D);
  static const dayOnBg = Color(0xFF1B1A17);
  static const dayOnSurface = Color(0xFF2E2C28);
  static const dayOnSurfaceVariant = Color(0xFF5A564F);
  static const dayScrim = Color(0xCC000000);

  // ── Dark mode: graphite ─────────────────────────────────────────────
  static const nightBg = Color(0xFF121110);
  static const nightSurface = Color(0xFF1C1A18);
  static const nightSurfaceAlt = Color(0xFF25231F);
  static const nightSurfaceHigh = Color(0xFF2E2B27);
  static const nightSurfaceElevated = Color(0xFF34312C);
  static const nightDivider = Color(0xFF3B3832);
  static const nightBorder = Color(0xFF3B3832);
  static const nightBorderStrong = Color(0xFF4C4842);
  static const nightTextPrimary = Color(0xFFF3F0EA);
  static const nightTextSecondary = Color(0xFFC9C3B8);
  static const nightTextMuted = Color(0xFFA9A398); // 6.6:1 on nightSurfaceAlt
  static const nightTextBody = Color(0xFFDEDAD2);
  static const nightMuted = Color(0xFF969085);
  static const nightMutedStrong = Color(0xFF6E6961);
  static const nightOnBg = Color(0xFFF3F0EA);
  static const nightOnSurface = Color(0xFFE6E2DA);
  static const nightOnSurfaceVariant = Color(0xFFB8B2A7);
  static const nightScrim = Color(0xCC000000);

  // ── Primary accent: burnt orange ────────────────────────────────────
  static const accentBlue = Color(0xFFE4572E); // vermilion: fills (ink text 4.7:1) and icons (≥3:1 both modes)
  static const accentBlueDim = Color(0xFFC2410C); // light-mode accent text; white text on it 5.2:1
  static const accentBlueSoft = Color(0xFFFBE9E1);
  static const accentBlueWash = Color(0xFFF6D5C6);
  static const accentBlueDeep = Color(0xFF7C2D12);
  static const accentBlueContainer = Color(0xFF5A2410);
  static const accentBlueDark = Color(0xFF9A3412);
  static const accentBlueLight = Color(0xFFF28A63); // dark-mode accent text and fills (ink text)

  // Accent soft for selected tile (no context needed)
  static const nightAccentSoft = accentBlueWash;
  static const dayAccentSoft = accentBlueSoft;

  // ── Accent variants ─────────────────────────────────────────────────
  static const accentTeal = Color(0xFFEF7349); // gradient end: same hue, a step lighter
  static const accentTealSoft = Color(0xFFFBE9E1);
  static const accentWarm = Color(0xFFD97706); // ratings / low-stock amber
  static const accentWarmSoft = Color(0xFFFDF0DC);
  static const accentGreen = Color(0xFF22883D); // white text 4.5:1, dark-mode icon 3.1:1
  static const accentGreenSoft = Color(0xFFE3F4E8);
  static const accentRed = Color(0xFFD2453E); // white text 4.5:1, dark-mode icon 3.1:1
  static const accentRedSoft = Color(0xFFFBE6E6);

  // Legacy aliases for backwards compatibility
  static const accentPurple = accentBlue;
  static const accentPurpleSoft = accentBlueSoft;
  static const accentOrange = accentWarm;
  static const accentOrangeSoft = accentWarmSoft;
  static const electricBlue = accentBlue;

  // ── Category colors: one accent, categories are told apart by icon ───
  static const catKeyboard = accentBlue;
  static const catMouse = accentBlue;
  static const catMonitor = accentBlue;
  static const catAudio = accentBlue;
  static const catCamera = accentBlue;
  static const catAccessory = accentBlue;

  // ── Status colors ───────────────────────────────────────────────────
  static const success = accentGreen;
  static const warning = accentWarm;
  static const danger = accentRed;
  static const info = accentBlue;
  static const error = accentRed;

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

  /// The primary accent tuned for the current mode (lighter in dark mode).
  static Color accent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? accentBlueLight : accentBlueDim;

  /// Returns [color] shifted in lightness until it reads at 4.5:1 against the
  /// current mode's darkest-on-light / lightest-on-dark surface. Neutrals (white
  /// badge text, greys) are returned unchanged; they are already tokenized.
  static Color readable(BuildContext context, Color color) {
    final hsl = HSLColor.fromColor(color);
    if (hsl.saturation < 0.15 || color.a < 1) return color;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bgLum = (dark ? nightSurfaceHigh : daySurfaceAlt).computeLuminance();
    double ratio(Color c) {
      final l = c.computeLuminance();
      return dark ? (l + 0.05) / (bgLum + 0.05) : (bgLum + 0.05) / (l + 0.05);
    }

    var h = hsl;
    for (var i = 0; i < 25 && ratio(h.toColor()) < 4.5; i++) {
      h = h.withLightness((h.lightness + (dark ? 0.03 : -0.03)).clamp(0.0, 1.0));
    }
    return h.toColor();
  }

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

}