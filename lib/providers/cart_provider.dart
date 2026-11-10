import 'package:flutter/material.dart';

import '../services/preferences_service.dart';
import '../models/app_models.dart';

/// Cart state. The in-memory list is the source of truth: every change is applied
/// synchronously, then persisted, so back-to-back adds (e.g. a whole build) can't
/// overwrite each other.
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

  /// Same product + same variant merges into one line.
  Future<void> addItem(CartItem item) {
    final i = _items.indexWhere(
      (x) =>
          x.component.id == item.component.id &&
          x.option?.id == item.option?.id &&
          x.selectedColor == item.selectedColor,
    );
    _items = [..._items];
    if (i >= 0) {
      _items[i] = _items[i].copyWith(
        quantity: _items[i].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    return _save();
  }

  /// Adds every selected part of a build, each with the variant chosen in the builder.
  Future<void> addBuild(BuildConfig build) {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    for (final c in build.components) {
      addItem(
        CartItem(
          id: 'cart_${c.id}_$stamp',
          component: c,
          quantity: 1,
          option: c.options.firstOrNull,
        ),
      );
    }
    return _save();
  }

  Future<void> removeItem(String cartItemId) {
    _items = _items.where((x) => x.id != cartItemId).toList();
    return _save();
  }

  Future<void> updateQuantity(String cartItemId, int quantity) {
    if (quantity <= 0) return removeItem(cartItemId);
    _items = [
      for (final x in _items)
        x.id == cartItemId ? x.copyWith(quantity: quantity) : x,
    ];
    return _save();
  }

  Future<void> clear() {
    _items = [];
    return _save();
  }

  // Alias for compatibility
  Future<void> clearAll() => clear();

  Future<void> _save() {
    notifyListeners();
    return PreferencesService.saveCart(_items);
  }
}
