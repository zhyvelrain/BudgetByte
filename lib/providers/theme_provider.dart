import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Theme provider for managing dark/light mode
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  /// What is actually on screen: "system" resolves to the device's current brightness.
  bool get isDarkMode =>
      _themeMode == ThemeMode.dark ||
      (_themeMode == ThemeMode.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await PreferencesService.getPreferences();
    _themeMode = _stringToThemeMode(prefs.themeMode);
    _isInitialized = true;
    notifyListeners();
  }

  /// Flips what the user currently sees (not the stored setting), then pins that choice.
  Future<void> toggleTheme() => setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await PreferencesService.getPreferences();
    await PreferencesService.savePreferences(prefs.copyWith(themeMode: _themeModeToString(_themeMode)));
  }

  ThemeMode _stringToThemeMode(String mode) {
      switch (mode) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
          return ThemeMode.system;
        default:
          return ThemeMode.system;
      }
    }

  String _themeModeToString(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.light:
          return 'light';
        case ThemeMode.dark:
          return 'dark';
        case ThemeMode.system:
          return 'system';
      }
    }
}