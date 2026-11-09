import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byte_budget/theme/bb_theme.dart';
import 'package:byte_budget/providers/theme_provider.dart';
import 'package:byte_budget/providers/cart_provider.dart';
import 'package:byte_budget/providers/build_provider.dart';
import 'package:byte_budget/services/preferences_service.dart';
import 'package:byte_budget/services/auth_service.dart';
import 'package:byte_budget/services/component_data_service.dart';
import 'package:byte_budget/providers/shop_provider.dart';
import 'package:byte_budget/models/app_models.dart';
import 'package:byte_budget/screens/product_detail_screen.dart';
import 'package:byte_budget/screens/saved_builds_screen.dart';
import 'package:byte_budget/screens/auth/login_screen.dart';
import 'package:byte_budget/screens/home/home_screen.dart';
import 'package:byte_budget/screens/builder/builder_screen.dart';
import 'package:byte_budget/screens/cart/cart_screen.dart';
import 'package:byte_budget/screens/profile/profile_screen.dart';
import 'package:byte_budget/screens/onboarding/onboarding_screen.dart';
import 'package:byte_budget/screens/main/main_screen.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  final screens = <String, Widget Function()>{
    'home': () => const HomeScreen(),
    'builder': () => const BuilderScreen(),
    'cart': () => const CartScreen(),
    'profile': () => const ProfileScreen(),
    'onboarding': () => OnboardingScreen(onComplete: () {}),
    'main': () => const MainScreen(),
    'login': () => const LoginScreen(),
    'detail': () =>
        ProductDetailScreen(component: ComponentDataService.components.first),
    'wishlist': () => const WishlistScreen(),
    'saved': () => const SavedBuildsScreen(),
  };
  for (final size in const [Size(360, 640), Size(390, 844)]) {
    for (final dark in [false, true]) {
      for (final e in screens.entries) {
        testWidgets('${e.key} ${size.width}x${size.height} dark=$dark', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues({});
          await PreferencesService.init();
          tester.view.physicalSize = size * 3;
          tester.view.devicePixelRatio = 3;
          final errors = <String>[];
          final old = FlutterError.onError;
          FlutterError.onError = (d) {
            final s = d.exceptionAsString();
            if (!s.contains('GoogleFonts') && !s.contains('google_fonts')) {
              errors.add(
                '${s.split('\n').first} @ ${RegExp(r'lib/[^ :]+:\d+').allMatches(d.toString().replaceAll('\\', '/')).map((m) => m.group(0)).take(2).join(',')}',
              );
            }
          };
          final t = ThemeProvider();
          final c = CartProvider();
          final b = BuildProvider();
          final a = AuthService()..init();
          final shop = ShopProvider();
          await tester.runAsync(() async {
            await t.init();
            await c.init();
            await b.init();
            for (final cat in ComponentCategory.values) {
              final p = ComponentDataService.getByCategory(cat).first;
              b.selectComponent(cat, p, option: p.options.last);
            }
            b.setBuildName('A rather long build name for the desk upstairs');
            await b.saveCurrentBuild();
            await shop.init();
            // Dark runs use pesos: the longest price strings.
            if (dark) await shop.setCurrency('PHP');
            for (final p in ComponentDataService.components.take(2)) {
              await c.addItem(
                CartItem(
                  id: p.id,
                  component: p,
                  quantity: 2,
                  option: p.options.last,
                ),
              );
              await shop.toggleFavorite(p.id);
            }
          });
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: t),
                ChangeNotifierProvider.value(value: c),
                ChangeNotifierProvider.value(value: b),
                ChangeNotifierProvider.value(value: a),
                ChangeNotifierProvider.value(value: shop),
              ],
              child: MaterialApp(
                theme: BBTheme.light(),
                darkTheme: BBTheme.dark(),
                themeMode: dark ? ThemeMode.dark : ThemeMode.light,
                home: e.value(),
              ),
            ),
          );
          await tester.pump(const Duration(seconds: 1));
          await tester.pump(const Duration(seconds: 1));
          FlutterError.onError = old;
          expect(errors.toSet(), isEmpty);
        });
      }
    }
  }
}
