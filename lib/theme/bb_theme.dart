import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bb_colors.dart';
import 'bb_text.dart';

/// ByteBudget Theme - Light & Dark themes with electric blue accent
/// Inspired by ProduceAIQ's AppTheme but adapted for PC peripheral e-commerce
class BBTheme {
  BBTheme._();

  // Cached themes
  static ThemeData? _light;
  static ThemeData? _dark;

  static ThemeData light() => _light ??= _build(Brightness.light);
  static ThemeData dark() => _dark ??= _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? BBColors.nightBg : BBColors.dayBg,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: BBColors.accentBlue,
        onPrimary: isDark ? BBColors.nightBg : BBColors.dayTextPrimary,
        primaryContainer: isDark ? BBColors.accentBlueDeep : BBColors.accentBlueSoft,
        onPrimaryContainer: isDark ? BBColors.white : BBColors.nightTextPrimary,
        secondary: BBColors.accentPurple,
        onSecondary: Colors.white,
        secondaryContainer: isDark ? BBColors.accentPurpleSoft : BBColors.accentPurpleSoft,
        onSecondaryContainer: isDark ? BBColors.nightBg : BBColors.dayTextPrimary,
        tertiary: BBColors.accentOrange,
        onTertiary: Colors.white,
        tertiaryContainer: isDark ? BBColors.accentOrangeSoft : BBColors.accentOrangeSoft,
        onTertiaryContainer: isDark ? BBColors.nightBg : BBColors.dayTextPrimary,
        error: BBColors.danger,
        onError: Colors.white,
        errorContainer: isDark ? BBColors.accentRedSoft : BBColors.accentRedSoft,
        onErrorContainer: isDark ? BBColors.nightBg : BBColors.dayTextPrimary,
        surface: isDark ? BBColors.nightSurface : BBColors.daySurface,
        onSurface: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
        surfaceContainerHighest: isDark ? BBColors.nightSurfaceAlt : BBColors.daySurfaceAlt,
        onSurfaceVariant: isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary,
        outline: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        outlineVariant: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        shadow: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.1),
        scrim: isDark ? Colors.black.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.3),
        inverseSurface: isDark ? BBColors.daySurface : BBColors.nightSurface,
        onInverseSurface: isDark ? BBColors.dayTextPrimary : BBColors.nightTextPrimary,
        inversePrimary: BBColors.accentBlueDim,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? BBColors.nightSurface.withValues(alpha: 0.95)
            : BBColors.daySurface.withValues(alpha: 0.95),
        foregroundColor: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: BBText.displaySmall(
          color: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
          size: 22,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: isDark ? BBColors.nightSurface : BBColors.daySurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
          side: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark
            ? BBColors.nightSurface.withValues(alpha: 0.95)
            : BBColors.daySurface.withValues(alpha: 0.95),
        selectedItemColor: BBColors.accentBlue,
        unselectedItemColor: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: BBColors.elevationLg,
        selectedLabelStyle: BBText.labelSmall(),
        unselectedLabelStyle: BBText.labelSmall(),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? BBColors.nightSurface.withValues(alpha: 0.95)
            : BBColors.daySurface.withValues(alpha: 0.95),
        indicatorColor: isDark ? BBColors.accentBlueWash : BBColors.accentBlueSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBText.labelSmall(color: BBColors.accentBlue);
          }
          return BBText.labelSmall(color: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: BBColors.accentBlue, size: 24);
          }
          return IconThemeData(
              color: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted, size: 22);
        }),
        height: 72,
        elevation: BBColors.elevationLg,
        shadowColor: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: BBText.displayLarge(),
        displayMedium: BBText.displayMedium(),
        displaySmall: BBText.displaySmall(),
        headlineLarge: BBText.headlineLarge(),
        headlineMedium: BBText.headlineMedium(),
        headlineSmall: BBText.headlineSmall(),
        titleLarge: BBText.headlineLarge(),
        titleMedium: BBText.headlineMedium(),
        titleSmall: BBText.headlineSmall(),
        bodyLarge: BBText.bodyLarge(),
        bodyMedium: BBText.bodyMedium(),
        bodySmall: BBText.bodySmall(),
        labelLarge: BBText.labelLarge(),
        labelMedium: BBText.labelMedium(),
        labelSmall: BBText.labelSmall(),
      ).apply(
        bodyColor: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
        displayColor: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? BBColors.nightSurfaceAlt : BBColors.daySurfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: BBColors.padL, vertical: BBColors.padM),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          borderSide: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          borderSide: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          borderSide: const BorderSide(color: BBColors.accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          borderSide: const BorderSide(color: BBColors.danger, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          borderSide: const BorderSide(color: BBColors.danger, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          borderSide: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
        labelStyle: BBText.bodyMedium(
          color: isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary,
        ),
        hintStyle: BBText.bodyMedium(
          color: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
        ),
        errorStyle: BBText.bodySmall(color: BBColors.danger),
        floatingLabelStyle: BBText.labelMedium(color: BBColors.accentBlue),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused) ? BBColors.accentBlue : (isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted)),
        suffixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused) ? BBColors.accentBlue : (isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted)),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BBColors.accentBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDark ? BBColors.nightDivider : BBColors.dayDivider,
          disabledForegroundColor: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BBColors.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: BBColors.padXL, vertical: BBColors.padM),
          elevation: BBColors.elevationSm,
          shadowColor: BBColors.electricBlueAt(0.3),
          textStyle: BBText.button(),
          minimumSize: const Size(88, 48),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return BBColors.electricBlueAt(0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return BBColors.electricBlueAt(0.05);
            }
            return Colors.transparent;
          }),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BBColors.accentBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BBColors.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: BBColors.padXL, vertical: BBColors.padM),
          textStyle: BBText.button(),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BBColors.accentBlue,
          side: const BorderSide(color: BBColors.accentBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BBColors.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: BBColors.padXL, vertical: BBColors.padM),
          textStyle: BBText.button(color: BBColors.accentBlue),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return BBColors.electricBlueAt(0.1);
            }
            if (states.contains(WidgetState.hovered)) {
              return BBColors.electricBlueAt(0.05);
            }
            return Colors.transparent;
          }),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BBColors.accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BBColors.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
          textStyle: BBText.button(),
        ),
      ),

      // FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: BBColors.accentBlue,
        foregroundColor: Colors.white,
        elevation: BBColors.elevationMd,
        focusElevation: BBColors.elevationMd,
        hoverElevation: BBColors.elevationLg,
        highlightElevation: BBColors.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
        ),
        extendedTextStyle: BBText.button(),
        extendedIconLabelSpacing: 10,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? BBColors.nightSurfaceAlt : BBColors.daySurfaceAlt,
        disabledColor: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        selectedColor: isDark ? BBColors.accentBlueWash : BBColors.accentBlueSoft,
        secondarySelectedColor: isDark ? BBColors.accentBlueWash : BBColors.accentBlueSoft,
        padding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
        labelStyle: BBText.labelMedium(),
        secondaryLabelStyle: BBText.labelMedium(color: Colors.white),
        brightness: brightness,
        elevation: 0,
        pressElevation: BBColors.elevationSm,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusFull),
          side: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        thickness: 1,
        space: 1,
        indent: 0,
        endIndent: 0,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: BBColors.padL, vertical: BBColors.padS),
        titleTextStyle: BBText.bodyLarge(color: isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary),
        subtitleTextStyle: BBText.bodyMedium(color: isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: isDark ? BBColors.nightAccentSoft : BBColors.dayAccentSoft,
        selectedColor: BBColors.accentBlue,
        iconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBColors.accentBlue;
          }
          return isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary;
        }),
        textColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBColors.accentBlue;
          }
          return isDark ? BBColors.nightTextPrimary : BBColors.dayTextPrimary;
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? BBColors.nightSurface : BBColors.daySurface,
        surfaceTintColor: Colors.transparent,
        elevation: BBColors.elevationLg,
        shadowColor: isDark
            ? Colors.black.withValues(alpha: 0.4)
            : Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusXl),
          side: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
        titleTextStyle: BBText.displaySmall(),
        contentTextStyle: BBText.bodyMedium(),
        alignment: Alignment.center,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? BBColors.nightSurface : BBColors.daySurface,
        surfaceTintColor: Colors.transparent,
        elevation: BBColors.elevationXl,
        shadowColor: isDark
            ? Colors.black.withValues(alpha: 0.4)
            : Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(BBColors.radiusXl),
          ),
        ),
        modalBackgroundColor: isDark ? BBColors.nightSurface : BBColors.daySurface,
        dragHandleColor: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        showDragHandle: true,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? BBColors.nightSurfaceElevated : BBColors.daySurfaceElevated,
        contentTextStyle: BBText.bodyMedium(),
        actionTextColor: BBColors.accentBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
        ),
        elevation: BBColors.elevationMd,
        showCloseIcon: false,
        closeIconColor: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? BBColors.nightSurfaceElevated : BBColors.daySurfaceElevated,
          borderRadius: BorderRadius.circular(BBColors.radiusMd),
          border: Border.all(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
        textStyle: BBText.labelSmall(color: isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary),
        padding: const EdgeInsets.symmetric(horizontal: BBColors.padM, vertical: BBColors.padS),
        verticalOffset: 24,
        preferBelow: true,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: BBColors.accentBlue,
        linearTrackColor: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        circularTrackColor: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        refreshBackgroundColor: isDark ? BBColors.nightSurfaceAlt : BBColors.daySurfaceAlt,
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: BBColors.accentBlue,
        inactiveTrackColor: isDark ? BBColors.nightDivider : BBColors.dayDivider,
        thumbColor: BBColors.accentBlue,
        overlayColor: BBColors.electricBlueAt(0.15),
        valueIndicatorColor: BBColors.accentBlue,
        valueIndicatorTextStyle: BBText.labelSmall(color: Colors.white),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: BBColors.accentBlue,
        unselectedLabelColor: isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted,
        indicatorColor: BBColors.accentBlue,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: BBText.labelMedium(weight: FontWeight.w600),
        unselectedLabelStyle: BBText.labelMedium(),
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return BBColors.electricBlueAt(0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return BBColors.electricBlueAt(0.05);
          }
          return Colors.transparent;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBColors.accentBlue;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(
          color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBColors.radiusSm),
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return BBColors.electricBlueAt(0.1);
          }
          return Colors.transparent;
        }),
        splashRadius: 20,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBColors.accentBlue;
          }
          return isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return BBColors.electricBlueAt(0.1);
          }
          return Colors.transparent;
        }),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBColors.accentBlue;
          }
          return isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBColors.electricBlueAt(0.3);
          }
          return isDark ? BBColors.nightDivider : BBColors.dayDivider;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return BBColors.electricBlueAt(0.1);
          }
          return Colors.transparent;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BBColors.accentBlue;
          }
          return isDark ? BBColors.nightDivider : BBColors.dayDivider;
        }),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary,
        size: 24,
      ),

      primaryIconTheme: IconThemeData(
        color: BBColors.accentBlue,
        size: 24,
      ),

      // Platform specific
      platform: TargetPlatform.android,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }
}