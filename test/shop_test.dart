import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byte_budget/models/app_models.dart';
import 'package:byte_budget/providers/cart_provider.dart';
import 'package:byte_budget/providers/shop_provider.dart';
import 'package:byte_budget/screens/home/home_screen.dart';
import 'package:byte_budget/screens/cart/cart_screen.dart';
import 'package:byte_budget/services/auth_service.dart';
import 'package:byte_budget/services/component_data_service.dart';
import 'package:byte_budget/services/preferences_service.dart';
import 'package:byte_budget/theme/bb_theme.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  test('catalog: 10 products, 1-3 variants each, one default', () {
    final all = ComponentDataService.components;
    expect(all, hasLength(10));
    for (final c in all) {
      expect(c.options.length, inInclusiveRange(1, 3), reason: c.name);
      expect(c.options.where((o) => o.isDefault), hasLength(1), reason: c.name);
    }
  });

  test('currency: formats, persists, ignores unknown codes', () async {
    final shop = ShopProvider();
    await shop.init();
    expect(shop.format(1299.99), '\$1,299.99');
    await shop.setCurrency('PHP');
    expect(shop.format(100), '₱5,600.00');
    await shop.setCurrency('EUR');
    expect(shop.currency, 'PHP');
    final reloaded = ShopProvider();
    await reloaded.init();
    expect(reloaded.currency, 'PHP');
  });

  test('favorites toggle and persist', () async {
    final shop = ShopProvider();
    await shop.init();
    await shop.toggleFavorite('kb_001');
    expect(shop.isFavorite('kb_001'), isTrue);
    expect(await PreferencesService.getFavorites(), {'kb_001'});
    await shop.toggleFavorite('kb_001');
    expect(shop.isFavorite('kb_001'), isFalse);
  });

  test(
    'cart: variants are separate lines, priced by variant, same variant merges',
    () async {
      final cart = CartProvider();
      await cart.init();
      final p = ComponentDataService.components.first;
      final base = p.options.first, edition = p.options.last;
      CartItem line(ComponentOption o) => CartItem(
        id: '${o.id}_${DateTime.now().microsecondsSinceEpoch}',
        component: p,
        quantity: 1,
        option: o,
      );

      await cart.addItem(line(base));
      await cart.addItem(line(base));
      await cart.addItem(line(edition));
      expect(cart.items, hasLength(2));
      expect(cart.itemCount, 3);
      expect(cart.subtotal, closeTo(base.price! * 2 + edition.price!, 0.001));
      expect(edition.price, greaterThan(base.price!));
    },
  );

  testWidgets('home: search, category filter, favorite, quick add', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844) * 3;
    tester.view.devicePixelRatio = 3;
    final cart = CartProvider();
    final shop = ShopProvider();
    await tester.runAsync(() async {
      await cart.init();
      await shop.init();
    });
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: cart),
          ChangeNotifierProvider.value(value: shop),
        ],
        child: MaterialApp(theme: BBTheme.light(), home: const HomeScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField), 'razer');
    await tester.pump();
    expect(find.text('Results for "razer"'), findsOneWidget);
    expect(find.text('2 products'), findsOneWidget);

    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pump();
    expect(shop.favorites, hasLength(1));

    await tester.tap(find.byTooltip('Add to cart').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 5)); // let the snackbar settle
    expect(cart.itemCount, 1);

    await tester.tap(find.text('Clear'));
    await tester.pump();
    await tester.tap(find.text('Keyboard').first);
    await tester.pump();
    expect(find.text('2 products'), findsOneWidget);
  });

  testWidgets('checkout asks for a shipping address before payment', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844) * 3;
    tester.view.devicePixelRatio = 3;
    final cart = CartProvider();
    final shop = ShopProvider();
    final p = ComponentDataService.components.first;
    await tester.runAsync(() async {
      await cart.init();
      await shop.init();
      await cart.addItem(
        CartItem(id: 'x', component: p, quantity: 1, option: p.options.first),
      );
    });
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: cart),
          ChangeNotifierProvider.value(value: shop),
          ChangeNotifierProvider.value(value: AuthService()..init()),
        ],
        child: MaterialApp(theme: BBTheme.light(), home: const CartScreen()),
      ),
    );

    await tester.tap(find.textContaining('Checkout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Enter your street address.'), findsOneWidget);
    expect(find.text('Payment Method'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full Name'),
      'Juan Dela Cruz',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'juan@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Street address'),
      '12 Rizal St, Brgy. Uno',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'City'),
      'Makati',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'ZIP Code'),
      '1200',
    );
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Payment Method'), findsOneWidget);
  });
}
