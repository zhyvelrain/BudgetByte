import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../models/app_models.dart';
import '../services/component_data_service.dart';

/// Build Config provider for managing PC Builder state
class BuildProvider extends ChangeNotifier {
  BuildConfig? _currentBuild;
  List<BuildConfig> _savedBuilds = [];
  bool _isInitialized = false;
  // Track selected option per category
  final Map<ComponentCategory, ComponentOption?> _selectedOptions = {};

  BuildConfig? get currentBuild => _currentBuild;
  // Alias for compatibility with screens
  BuildConfig? get build => _currentBuild;
  List<BuildConfig> get savedBuilds => List.unmodifiable(_savedBuilds);
  bool get isInitialized => _isInitialized;

  double get currentBuildTotal => _currentBuild?.totalPrice ?? 0;
  int get currentBuildComponentCount => _currentBuild?.componentCount ?? 0;
  bool get isCurrentBuildComplete => _currentBuild?.isComplete ?? false;

  ComponentOption? getSelectedOption(ComponentCategory category) {
    return _selectedOptions[category];
  }

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
    // Keep only the chosen variant so price, cart and history all agree on it.
    newComponents[category] = option == null ? component : component?.copyWith(options: [option]);
    _currentBuild = _currentBuild!.copyWith(
      selectedComponents: newComponents,
      updatedAt: DateTime.now(),
    );
    if (component != null && option != null) {
      _selectedOptions[category] = option;
    } else {
      _selectedOptions.remove(category);
    }
    notifyListeners();
  }

  void clearComponent(ComponentCategory category) {
    selectComponent(category, null);
    _selectedOptions.remove(category);
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

  /// Saves the current build, updating it in place if it was saved before.
  Future<void> saveCurrentBuild() => _upsert(_currentBuild!.copyWith(updatedAt: DateTime.now()));

  Future<void> renameBuild(String buildId, String name) async {
    final build = _savedBuilds.where((b) => b.id == buildId).firstOrNull;
    if (build == null || name.trim().isEmpty) return;
    await _upsert(build.copyWith(name: name.trim(), updatedAt: DateTime.now()));
    if (_currentBuild?.id == buildId) _currentBuild = _currentBuild!.copyWith(name: name.trim());
  }

  Future<void> duplicateBuild(String buildId) async {
    final build = _savedBuilds.where((b) => b.id == buildId).firstOrNull;
    if (build == null) return;
    final now = DateTime.now();
    await _upsert(build.copyWith(
      id: 'build_${now.microsecondsSinceEpoch}',
      name: '${build.name} (Copy)',
      createdAt: now,
      updatedAt: now,
    ));
  }

  Future<void> _upsert(BuildConfig build) async {
    _savedBuilds = [build, ..._savedBuilds.where((b) => b.id != build.id)];
    notifyListeners();
    await PreferencesService.saveBuilds(_savedBuilds);
  }

  // Alias for compatibility
  Future<void> saveBuild() async => saveCurrentBuild();

  Future<void> loadBuild(String buildId) async {
    final build = _savedBuilds.firstWhere((b) => b.id == buildId, orElse: () => _createEmptyBuild());
    _currentBuild = build;
    notifyListeners();
  }

  Future<void> deleteBuild(String buildId) async {
    _savedBuilds = _savedBuilds.where((b) => b.id != buildId).toList();
    if (_currentBuild?.id == buildId) _currentBuild = _createEmptyBuild();
    notifyListeners();
    await PreferencesService.saveBuilds(_savedBuilds);
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