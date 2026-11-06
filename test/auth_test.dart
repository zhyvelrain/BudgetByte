import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byte_budget/services/auth_service.dart';
import 'package:byte_budget/services/preferences_service.dart';

void main() {
  test('sign up, persist session, sign in, reject bad input', () async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
    final auth = AuthService()..init();

    expect(
      await auth.signUp(name: 'A', email: 'a@b.co', password: 'password1'),
      isNotNull,
    ); // short name
    expect(
      await auth.signUp(name: 'Ada', email: 'nope', password: 'password1'),
      isNotNull,
    );
    expect(
      await auth.signUp(name: 'Ada', email: 'a@b.co', password: 'short'),
      isNotNull,
    );
    expect(
      await auth.signUp(
        name: 'Ada',
        email: ' Ada@B.co ',
        password: 'password1',
      ),
      isNull,
    );
    expect(auth.currentUser!.email, 'ada@b.co');
    expect(
      await auth.signUp(name: 'Ada', email: 'ada@b.co', password: 'password1'),
      isNotNull,
    ); // duplicate

    expect(
      PreferencesService.prefs.getString('bytebudget_users'),
      isNot(contains('password1')),
    );
    expect(
      (AuthService()..init()).currentUser?.name,
      'Ada',
    ); // session survives restart

    await auth.signOut();
    expect((AuthService()..init()).signedIn, isFalse);
    expect(
      await auth.signIn(email: 'ada@b.co', password: 'wrongpass'),
      isNotNull,
    );
    expect(await auth.signIn(email: 'ADA@b.co', password: 'password1'), isNull);
    expect(auth.signedIn, isTrue);
  });
}
