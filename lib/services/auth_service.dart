import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'preferences_service.dart';

class User {
  final String email;
  final String name;
  final String salt;
  final String passwordHash;
  final DateTime createdAt;

  User({
    required this.email,
    required this.name,
    required this.salt,
    required this.passwordHash,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'salt': salt,
    'passwordHash': passwordHash,
    'createdAt': createdAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> j) => User(
    email: j['email'] as String,
    name: j['name'] as String,
    salt: j['salt'] as String,
    passwordHash: j['passwordHash'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}

/// Local-only accounts kept in SharedPreferences. No backend.
// ponytail: salted SHA-256 is enough for on-device demo accounts; use a real
// auth provider (and a slow KDF) the day accounts leave the device.
class AuthService extends ChangeNotifier {
  static const _usersKey = 'bytebudget_users';
  static const _sessionKey = 'bytebudget_session';
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final Map<String, User> _users = {};
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get signedIn => _currentUser != null;
  bool get hasAccounts => _users.isNotEmpty;

  void init() {
    final prefs = PreferencesService.prefs;
    final raw = prefs.getString(_usersKey);
    if (raw != null) {
      for (final e in jsonDecode(raw) as List) {
        final u = User.fromJson(e as Map<String, dynamic>);
        _users[u.email] = u;
      }
    }
    _currentUser = _users[prefs.getString(_sessionKey)];
  }

  static String? validateName(String? v) => (v == null || v.trim().length < 2)
      ? 'Enter your name (at least 2 characters).'
      : null;

  static String? validateEmail(String? v) =>
      _emailPattern.hasMatch(v?.trim() ?? '')
      ? null
      : 'Enter a valid email, like you@example.com.';

  static String? validatePassword(String? v) =>
      (v == null || v.length < 8) ? 'Use at least 8 characters.' : null;

  /// Returns an error message, or null on success (and signs the user in).
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final key = email.trim().toLowerCase();
    final error =
        validateName(name) ?? validateEmail(key) ?? validatePassword(password);
    if (error != null) return error;
    if (_users.containsKey(key)) {
      return 'An account with this email already exists. Sign in instead.';
    }

    final salt = base64Url.encode(
      List.generate(16, (_) => Random.secure().nextInt(256)),
    );
    _users[key] = User(
      email: key,
      name: name.trim(),
      salt: salt,
      passwordHash: _hash(salt, password),
      createdAt: DateTime.now(),
    );
    await PreferencesService.prefs.setString(
      _usersKey,
      jsonEncode(_users.values.map((u) => u.toJson()).toList()),
    );
    return _startSession(_users[key]!);
  }

  /// Returns an error message, or null on success.
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    final u = _users[email.trim().toLowerCase()];
    if (u == null || u.passwordHash != _hash(u.salt, password)) {
      return 'That email and password don\'t match an account on this device.';
    }
    return _startSession(u);
  }

  Future<void> signOut() async {
    _currentUser = null;
    await PreferencesService.prefs.remove(_sessionKey);
    notifyListeners();
  }

  Future<String?> _startSession(User u) async {
      _currentUser = u;
      await PreferencesService.prefs.setString(_sessionKey, u.email);
      notifyListeners();
      return null;
    }

    /// Updates the current user's name. Returns error message or null on success.
    Future<String?> updateProfile({required String name}) async {
      if (_currentUser == null) return 'No user signed in.';
      final error = validateName(name);
      if (error != null) return error;
      final updatedUser = User(
        email: _currentUser!.email,
        name: name.trim(),
        salt: _currentUser!.salt,
        passwordHash: _currentUser!.passwordHash,
        createdAt: _currentUser!.createdAt,
      );
      _users[updatedUser.email] = updatedUser;
      _currentUser = updatedUser;
      await PreferencesService.prefs.setString(
        _usersKey,
        jsonEncode(_users.values.map((u) => u.toJson()).toList()),
      );
      notifyListeners();
      return null;
    }

    static String _hash(String salt, String password) =>
        sha256.convert(utf8.encode('$salt:$password')).toString();
  }
