// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byte_budget/main.dart';
import 'package:byte_budget/services/preferences_service.dart';

void main() {
  testWidgets('ByteBudget app loads without crashing', (WidgetTester tester) async {
    // Mock SharedPreferences to avoid hanging in test environment
    SharedPreferences.setMockInitialValues({});
    
    // Initialize PreferencesService with mocked SharedPreferences
    await PreferencesService.init();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ByteBudgetApp());

    // Verify the app title is shown in splash screen
    expect(find.text('ByteBudget'), findsOneWidget);
  });
}
