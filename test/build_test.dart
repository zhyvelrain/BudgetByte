import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byte_budget/models/app_models.dart';
import 'package:byte_budget/providers/build_provider.dart';
import 'package:byte_budget/providers/cart_provider.dart';
import 'package:byte_budget/providers/shop_provider.dart';
import 'package:byte_budget/providers/theme_provider.dart';
import 'package:byte_budget/screens/builder/builder_screen.dart';
import 'package:byte_budget/services/component_data_service.dart';
import 'package:byte_budget/services/preferences_service.dart';
import 'package:byte_budget/theme/bb_colors.dart';
import 'package:byte_budget/theme/bb_theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
}

/// One pick per category, using each product's last variant.
BuildProvider _fullBuild(BuildProvider p) {
  for (final cat in ComponentCategory.values) {
    final c = ComponentDataService.getByCategory(cat).first;
    p.selectComponent(cat, c, option: c.options.last);
  }
  return p;
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  test(
    'cart: rapid unawaited adds all land (no read-modify-write race)',
    () async {
      final cart = CartProvider();
      await cart.init();
      final parts = ComponentDataService.components.take(5).toList();
      final pending = [
        for (final p in parts)
          cart.addItem(CartItem(id: p.id, component: p, quantity: 1)),
      ];
      await Future.wait(pending);
      expect(cart.items, hasLength(5));
      expect(await PreferencesService.getCart(), hasLength(5));
    },
  );

  test(
    'finished build: every part reaches the cart with its chosen variant',
    () async {
      final builds = _fullBuild(BuildProvider()..startNewBuild());
      final build = builds.currentBuild!;
      expect(build.isComplete, isTrue);

      final cart = CartProvider();
      await cart.init();
      await cart.addBuild(build);

      expect(cart.items, hasLength(ComponentCategory.values.length));
      for (final item in cart.items) {
        expect(
          item.option?.id,
          endsWith('_v2'),
          reason: item.component.name,
        ); // last variant kept
      }
      expect(cart.subtotal, closeTo(build.totalPrice, 0.001));
      expect(
        build.totalPrice,
        greaterThan(
          ComponentCategory.values
              .map((c) => ComponentDataService.getByCategory(c).first.price)
              .reduce((a, b) => a + b),
        ),
      ); // variant prices, not base prices
    },
  );

  test('build history: save is an upsert; rename, duplicate, delete refresh the list', () async {
    final builds = BuildProvider();
    await builds.init();
    _fullBuild(builds);
    await builds.saveCurrentBuild();
    await builds.saveCurrentBuild();
    expect(builds.savedBuilds, hasLength(1));

    final id = builds.savedBuilds.single.id;
    await builds.renameBuild(id, '  Desk setup ');
    expect(builds.savedBuilds.single.name, 'Desk setup');

    await builds.duplicateBuild(id);
    expect(
      builds.savedBuilds.map((b) => b.name),
      containsAll(['Desk setup', 'Desk setup (Copy)']),
    );

    await builds.deleteBuild(id);
    expect(builds.savedBuilds.map((b) => b.name), ['Desk setup (Copy)']);

    final reloaded = BuildProvider();
    await reloaded.init();
    expect(
      reloaded.savedBuilds.single.components.first.options,
      hasLength(1),
    ); // variant persisted
  });

  testWidgets('builder: picking a variant moves to the next empty step', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844) * 3;
    tester.view.devicePixelRatio = 3;
    final builds = BuildProvider(),
        cart = CartProvider(),
        shop = ShopProvider();
    await tester.runAsync(() async {
      await builds.init();
      await cart.init();
      await shop.init();
    });
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: builds),
          ChangeNotifierProvider.value(value: cart),
          ChangeNotifierProvider.value(value: shop),
        ],
        child: MaterialApp(
          theme: BBTheme.light(),
          home: Builder(
            builder: (context) => MediaQuery(
              // The live 3D preview auto-rotates forever; disable that motion so
              // pumpAndSettle can reach a quiet frame.
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: const BuilderScreen(),
            ),
          ),
        ),
      ),
    );
    final tabs = DefaultTabController.of(
      tester.element(find.byType(TabBarView)),
    );
    expect(tabs.index, 0);

    final keyboard = ComponentDataService.getByCategory(
      ComponentCategory.keyboard,
    ).first;
    await tester.tap(find.text(keyboard.name));
    await tester.pumpAndSettle();
    await tester.tap(find.text(keyboard.options.last.name).last);
    await tester.pumpAndSettle();

    expect(
      builds
          .getSelectedComponent(ComponentCategory.keyboard)
          ?.options
          .single
          .name,
      keyboard.options.last.name,
    );
    expect(tabs.index, 1);
  });

  testWidgets(
    'theme: switch state follows what is on screen when following the system',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final theme = ThemeProvider();
      await tester.runAsync(theme.init);
      expect(theme.themeMode, ThemeMode.system);
      expect(theme.isDarkMode, isTrue);
      await tester.runAsync(theme.toggleTheme);
      expect(theme.themeMode, ThemeMode.light);
      expect(theme.isDarkMode, isFalse);
    },
  );

  testWidgets('contrast: text tokens and readable() pass 4.5:1 in both modes', (
    tester,
  ) async {
    const pairs = {
      'day muted/bg': (BBColors.dayTextMuted, BBColors.dayBg),
      'day muted/alt': (BBColors.dayTextMuted, BBColors.daySurfaceAlt),
      'day secondary/alt': (BBColors.dayTextSecondary, BBColors.daySurfaceAlt),
      'night muted/high': (BBColors.nightTextMuted, BBColors.nightSurfaceHigh),
      'night secondary/high': (
        BBColors.nightTextSecondary,
        BBColors.nightSurfaceHigh,
      ),
      'ink on accent fill': (BBColors.dayTextPrimary, BBColors.accentBlue),
      'ink on gradient end': (BBColors.dayTextPrimary, BBColors.accentTeal),
      'white on red badge': (Colors.white, BBColors.accentRed),
      'white on theme primary (light)': (Colors.white, BBColors.accentBlueDim),
    };
    pairs.forEach(
      (name, p) => expect(
        _contrast(p.$1, p.$2),
        greaterThanOrEqualTo(4.5),
        reason: name,
      ),
    );

    for (final dark in [false, true]) {
      // Plain Theme: MaterialApp would animate between themes for a few frames.
      await tester.pumpWidget(
        Theme(
          data: dark ? BBTheme.dark() : BBTheme.light(),
          child: Builder(
            builder: (context) {
              final bg = dark
                  ? BBColors.nightSurfaceHigh
                  : BBColors.daySurfaceAlt;
              for (final c in [
                BBColors.accentBlue,
                BBColors.accentGreen,
                BBColors.accentRed,
                BBColors.accentWarm,
              ]) {
                expect(
                  _contrast(BBColors.readable(context, c), bg),
                  greaterThanOrEqualTo(4.5),
                  reason: '$c dark=$dark',
                );
              }
              return const SizedBox();
            },
          ),
        ),
      );
    }
  });
}
