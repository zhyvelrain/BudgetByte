import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byte_budget/main.dart';
import 'package:byte_budget/services/preferences_service.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('first run shows onboarding, then account creation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
    await tester.pumpWidget(const ByteBudgetApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Welcome to ByteBudget'), findsOneWidget);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.textContaining(i == 4 ? 'Get Started' : 'Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Create your account'), findsOneWidget);
  });
}
