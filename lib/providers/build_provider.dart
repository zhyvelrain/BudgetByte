import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../models/app_models.dart';
import '../services/component_data_service.dart';

/// Build Config provider for managing PC Builder state
class BuildProvider extends ChangeNotifier {
  BuildConfig? _currentBuild;
  List<BuildConfig> _savedBuilds = [];
  bool _isInitialized = false;

  BuildConfig? get currentBuild => _currentBuild;
  // Alias for compatibility with screens
  BuildConfig? get build => _currentBuild;
  List<BuildConfig> get savedBuilds => List.unmodifiable(_savedBuilds);
  bool get isInitialized => _isInitialized;

  double get currentBuildTotal => _currentBuild?.totalPrice ?? 0;
  int get currentBuildComponentCount => _currentBuild?.componentCount ?? 0;
  bool get isCurrentBuildComplete => _currentBuild?.isComplete ?? false;

  Future<void> init() async {
    if (_isInitialized) return;
    _savedBuilds = await PreferencesService.getBuilds();
    // Create a new empty build if none exists
    _currentBuild ??= _createEmptyBuild();
    _isInitialized = true;
    notifyListeners();
  }

  BuildConfig _createEmptyBuild({String? name}) {
    final components = <ComponentCategory, Component?>{};
    for (final category in ComponentCategory.values) {
      components[category] = null;
    }
    return BuildConfig(
      id: 'build_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'My Build ${DateTime.now().day}/${DateTime.now().month}',
      selectedComponents: components,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void startNewBuild({String? name}) {
    _currentBuild = _createEmptyBuild(name: name);
    notifyListeners();
  }

  void selectComponent(ComponentCategory category, Component? component, {ComponentOption? option}) {
    if (_currentBuild == null) return;
    final newComponents = Map<ComponentCategory, Component?>.from(_currentBuild!.selectedComponents);
    newComponents[category] = component;
    _currentBuild = _currentBuild!.copyWith(
      selectedComponents: newComponents,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void clearComponent(ComponentCategory category) {
    selectComponent(category, null);
  }

  void setColorTheme(String? colorTheme) {
    if (_currentBuild == null) return;
    _currentBuild = _currentBuild!.copyWith(
      selectedColorTheme: colorTheme,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void setBuildName(String name) {
    if (_currentBuild == null) return;
    _currentBuild = _currentBuild!.copyWith(
      name: name,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> saveCurrentBuild() async {
    if (_currentBuild == null) return;
    await PreferencesService.addBuild(_currentBuild!);
    _savedBuilds = await PreferencesService.getBuilds();
    notifyListeners();
  }

  // Alias for compatibility
  Future<void> saveBuild() async => saveCurrentBuild();

  Future<void> loadBuild(String buildId) async {
    final build = _savedBuilds.firstWhere((b) => b.id == buildId, orElse: () => _createEmptyBuild());
    _currentBuild = build;
    notifyListeners();
  }

  Future<void> deleteBuild(String buildId) async {
    await PreferencesService.deleteBuild(buildId);
    _savedBuilds = await PreferencesService.getBuilds();
    if (_currentBuild?.id == buildId) {
      _currentBuild = _createEmptyBuild();
    }
    notifyListeners();
  }

  Future<void> addBuildToCart() async {
    if (_currentBuild == null || !_currentBuild!.isComplete) return;
    // This will be handled by the UI with cart provider
    notifyListeners();
  }

  List<Component> getAvailableComponentsForCategory(ComponentCategory category) {
    return ComponentDataService.getByCategory(category).where((c) => c.isInStock).toList();
  }

  Component? getSelectedComponent(ComponentCategory category) {
    return _currentBuild?.selectedComponents[category];
  }

  void clearCurrentBuild() {
    _currentBuild = _createEmptyBuild();
    notifyListeners();
  }
}