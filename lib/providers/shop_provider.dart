import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/preferences_service.dart';

/// Shopper preferences: display currency and favorites. Prices are stored in USD.
class ShopProvider extends ChangeNotifier {
  // ponytail: fixed demo rate; swap for a rates feed if prices ever go live.
  static const phpPerUsd = 56.0;
  static const currencies = {
    'USD': 'US Dollar (\$)',
    'PHP': 'Philippine Peso (₱)',
  };

  String _currency = 'USD';
  Set<String> _favorites = {};

  String get currency => _currency;
  Set<String> get favorites => _favorites;
  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> init() async {
    final prefs = await PreferencesService.getPreferences();
    _currency = currencies.containsKey(prefs.preferredCurrency)
        ? prefs.preferredCurrency!
        : 'USD';
    _favorites = await PreferencesService.getFavorites();
    notifyListeners();
  }

  Future<void> setCurrency(String code) async {
    if (!currencies.containsKey(code) || code == _currency) return;
    _currency = code;
    notifyListeners();
    final prefs = await PreferencesService.getPreferences();
    await PreferencesService.savePreferences(
      prefs.copyWith(preferredCurrency: code),
    );
  }

  Future<void> toggleFavorite(String id) async {
    _favorites = {..._favorites};
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
    await PreferencesService.saveFavorites(_favorites);
  }

  /// Formats a USD amount in the selected currency, e.g. "$1,299.99" or "₱72,799.44".
  String format(num usd) {
    final php = _currency == 'PHP';
    final parts = (php ? usd * phpPerUsd : usd).toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '${php ? '₱' : '\$'}$whole.${parts[1]}';
  }
}

extension Money on BuildContext {
  /// Price in the user's currency; rebuilds the caller when the currency changes.
  String money(num usd) => watch<ShopProvider>().format(usd);
}
