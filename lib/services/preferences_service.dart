import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/app_models.dart';

/// Service for managing user preferences with SharedPreferences
class PreferencesService {
  static const _prefsKey = 'bytebudget_preferences';
  static const _cartKey = 'bytebudget_cart';
  static const _buildsKey = 'bytebudget_builds';
  static const _ordersKey = 'bytebudget_orders';
  static const _favoritesKey = 'bytebudget_favorites';
  static const _addressKey = 'bytebudget_address';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('PreferencesService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // User Preferences
  static Future<UserPreferences> getPreferences() async {
    final jsonStr = prefs.getString(_prefsKey);
    if (jsonStr != null) {
      return UserPreferences.fromJson(jsonDecode(jsonStr));
    }
    return UserPreferences();
  }

  static Future<void> savePreferences(UserPreferences prefs) async {
    await PreferencesService.prefs.setString(_prefsKey, jsonEncode(prefs.toJson()));
  }

  // Cart
  static Future<List<CartItem>> getCart() async {
    final jsonStr = prefs.getString(_cartKey);
    if (jsonStr != null) {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  static Future<void> saveCart(List<CartItem> cart) async {
    await prefs.setString(_cartKey, jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  // Build Configurations
  static Future<List<BuildConfig>> getBuilds() async {
    final jsonStr = prefs.getString(_buildsKey);
    if (jsonStr != null) {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => BuildConfig.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  static Future<void> saveBuilds(List<BuildConfig> builds) async {
    await prefs.setString(_buildsKey, jsonEncode(builds.map((e) => e.toJson()).toList()));
  }

  // Orders
  static Future<List<Order>> getOrders() async {
    final jsonStr = prefs.getString(_ordersKey);
    if (jsonStr != null) {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  static Future<void> saveOrders(List<Order> orders) async {
    await prefs.setString(_ordersKey, jsonEncode(orders.map((e) => e.toJson()).toList()));
  }

  static Future<void> addOrder(Order order) async {
    final orders = await getOrders();
    orders.insert(0, order); // Most recent first
    await saveOrders(orders);
  }

  // Favorites
  static Future<Set<String>> getFavorites() async {
    final jsonStr = prefs.getString(_favoritesKey);
    if (jsonStr != null) {
      return Set<String>.from(jsonDecode(jsonStr) as List);
    }
    return <String>{};
  }

  static Future<void> saveFavorites(Set<String> favorites) async {
    await prefs.setString(_favoritesKey, jsonEncode(favorites.toList()));
  }

  static Future<void> toggleFavorite(String componentId) async {
    final favorites = await getFavorites();
    if (favorites.contains(componentId)) {
      favorites.remove(componentId);
    } else {
      favorites.add(componentId);
    }
    await saveFavorites(favorites);
  }

  static Future<bool> isFavorite(String componentId) async {
    final favorites = await getFavorites();
    return favorites.contains(componentId);
  }

  // Saved shipping address
  static Address? getAddress() {
    final jsonStr = prefs.getString(_addressKey);
    return jsonStr == null ? null : Address.fromJson(jsonDecode(jsonStr));
  }

  static Future<void> saveAddress(Address address) async {
    await prefs.setString(_addressKey, jsonEncode(address.toJson()));
  }

  static Future<void> clearAllData() async {
    await prefs.remove(_prefsKey);
    await prefs.remove(_cartKey);
    await prefs.remove(_buildsKey);
    await prefs.remove(_ordersKey);
    await prefs.remove(_favoritesKey);
  }
}