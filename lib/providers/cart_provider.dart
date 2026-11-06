import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../models/app_models.dart';

/// Cart provider for managing cart state
class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isInitialized = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isInitialized => _isInitialized;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);
  double get tax => subtotal * 0.12; // 12% VAT (Philippines)
  double get shipping => subtotal > 5000 ? 0 : 150; // Free shipping over ₱5,000
  double get total => subtotal + tax + shipping;

  Future<void> init() async {
    if (_isInitialized) return;
    _items = await PreferencesService.getCart();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addItem(CartItem item) async {
    await PreferencesService.addToCart(item);
    _items = await PreferencesService.getCart();
    notifyListeners();
  }

  Future<void> removeItem(String cartItemId) async {
    await PreferencesService.removeFromCart(cartItemId);
    _items = await PreferencesService.getCart();
    notifyListeners();
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await PreferencesService.updateCartQuantity(cartItemId, quantity);
    _items = await PreferencesService.getCart();
    notifyListeners();
  }

  Future<void> clear() async {
    await PreferencesService.clearCart();
    _items = [];
    notifyListeners();
  }

  // Alias for compatibility
  Future<void> clearAll() async => clear();

  bool isInCart(Component component, {String? selectedColor}) {
    return _items.any((item) =>
        item.component.id == component.id &&
        item.selectedColor == selectedColor);
  }

  // Add items from a build configuration
  Future<void> addBuild(BuildConfig build) async {
    for (final component in build.components) {
      final item = CartItem(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}_${component.id}',
        component: component,
        quantity: 1,
        selectedColor: build.selectedColorTheme,
      );
      await PreferencesService.addToCart(item);
    }
    _items = await PreferencesService.getCart();
    notifyListeners();
  }

  int getQuantityForComponent(Component component, {String? selectedColor}) {
    final item = _items.firstWhere(
      (item) =>
          item.component.id == component.id &&
          item.selectedColor == selectedColor,
      orElse: () => CartItem(
        id: '',
        component: component,
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}