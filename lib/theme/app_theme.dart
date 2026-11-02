import 'package:flutter/material.dart';
import 'package:byte_budget/theme/k_colors.dart';

/// Light / dark theme with a smooth transition.
///
/// Switched via [ThemeService.notify]. The [AnimatedSwitcher] on the page
/// root (in [MainApp]) gives the color scheme a clean cross-fade.
class ByteBudgetTheme {
  ByteBudgetTheme._();

  // ── Palette ────────────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: KColors.blue500,
        primaryContainer: KColors.blue100,
        secondary: KColors.cream900,
        secondaryContainer: KColors.cream700,
        surface: KColors.cream200,
        surfaceContainer: KColors.cream300,
        error: KColors.danger,
        onPrimary: KColors.white,
        onSecondary: KColors.white,
        onSurface: KColors.ink,
        onError: KColors.white,
        onPrimaryContainer: KColors.richBlue,
        onSecondaryContainer: KColors.ink,
        outline: KColors.cream400,
        outlineVariant: KColors.cream500,
      ),
      scaffoldBackgroundColor: KColors.cream200,
      cardColor: KColors.cream300,
      appBarTheme: const AppBarTheme(
        backgroundColor: KColors.cream200,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: KColors.ink),
        titleTextStyle: TextStyle(
          color: KColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: KColors.cream200,
        selectedItemColor: KColors.blue500,
        unselectedItemColor: KColors.inkFaint,
        type: BottomNavigationBarType.fixed,
        elevation: 6,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: KColors.ink),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: KColors.ink),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: KColors.ink),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: KColors.ink),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: KColors.ink),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: KColors.inkSoft),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: KColors.inkFaint),
        bodyLarge: TextStyle(fontSize: 15, color: KColors.ink),
        bodyMedium: TextStyle(fontSize: 14, color: KColors.inkSoft),
        bodySmall: TextStyle(fontSize: 12, color: KColors.inkFaint),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KColors.cream100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.cream400, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.cream400, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.blue500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.danger, width: 1.4),
        ),
        hintStyle: const TextStyle(color: KColors.inkFaint),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: KColors.blue500,
        foregroundColor: KColors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KColors.blue500,
          foregroundColor: KColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KColors.radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: KColors.cream300,
          foregroundColor: KColors.blue500,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KColors.radiusMd)),
          side: const BorderSide(color: KColors.blue500, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: KColors.blue500),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: KColors.blue300,
        primaryContainer: KColors.blue200,
        secondary: KColors.cream900,
        secondaryContainer: KColors.cream800,
        surface: KColors.cream700,
        surfaceContainer: KColors.cream800,
        error: KColors.danger,
        onPrimary: KColors.blue900,
        onSecondary: KColors.ink,
        onSurface: KColors.cream950,
        onError: KColors.cream950,
        onPrimaryContainer: KColors.blue900,
        onSecondaryContainer: KColors.ink,
        outline: KColors.cream600,
        outlineVariant: KColors.cream700,
      ),
      scaffoldBackgroundColor: KColors.cream700,
      cardColor: KColors.cream800,
      appBarTheme: const AppBarTheme(
        backgroundColor: KColors.cream700,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: KColors.cream950),
        titleTextStyle: TextStyle(
          color: KColors.cream950,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: KColors.cream700,
        selectedItemColor: KColors.blue300,
        unselectedItemColor: KColors.cream700,
        type: BottomNavigationBarType.fixed,
        elevation: 6,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: KColors.cream950),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: KColors.cream950),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: KColors.cream950),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: KColors.cream950),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: KColors.cream950),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: KColors.cream800),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: KColors.cream700),
        bodyLarge: TextStyle(fontSize: 15, color: KColors.cream950),
        bodyMedium: TextStyle(fontSize: 14, color: KColors.cream800),
        bodySmall: TextStyle(fontSize: 12, color: KColors.cream700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KColors.cream800,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.cream600, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.cream600, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.blue300, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KColors.radiusMd),
          borderSide: const BorderSide(color: KColors.danger, width: 1.4),
        ),
        hintStyle: const TextStyle(color: KColors.cream700),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: KColors.blue300,
        foregroundColor: KColors.blue900,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KColors.blue300,
          foregroundColor: KColors.blue900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KColors.radiusMd)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: KColors.cream800,
          foregroundColor: KColors.blue300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KColors.radiusMd)),
          side: const BorderSide(color: KColors.blue300, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: KColors.blue300),
      ),
    );
  }
}
