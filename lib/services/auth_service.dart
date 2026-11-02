import 'dart:convert';
import 'dart:io';

class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final DateTime createdAt;

  User({required this.id, required this.email, required this.password,
    required this.name, required this.createdAt});

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'],
    email: j['email'],
    password: j['password'],
    name: j['name'],
    createdAt: DateTime.parse(j['createdAt']),
  );
}

class AuthService {
  static final AuthService _s = AuthService._();

  AuthService._();

  factory AuthService() => _s;

  static const _file = 'data/users.json';
  bool _signedIn = false;
  User? _currentUser;
  final List<User> _users = [];

  bool get signedIn => _signedIn;
  User? get currentUser => _currentUser;

  Future<void> init() async {
    final f = File(_file);
    if (await f.exists()) {
      final raw = await f.readAsString();
      if (raw.trim().isNotEmpty) {
        final List<dynamic> d = json.decode(raw);
        _users.addAll(d.map((e) => User.fromJson(e as Map<String, dynamic>)));
      }
    }
    _signedIn = await f.exists() && (await f.readAsString()).trim().isNotEmpty;
    if (_signedIn) {
      final idx = _users.indexWhere((u) => u.email == 'demo@bytebudget.io');
      if (idx >= 0) _currentUser = _users[idx];
    }
  }

  Future<String> signUp({required String email, required String password, required String name}) async {
    if (email.isEmpty || !email.contains('@')) return 'Enter a valid email.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    if (_users.any((u) => u.email == email)) return 'An account with this email already exists.';
    final u = User(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      email: email, password: password, name: name, createdAt: DateTime.now(),
    );
    _users.add(u);
    await _save();
    return '';
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      final u = _users.firstWhere(
        (x) => x.email == email && x.password == password,
      );
      _currentUser = u;
      _signedIn = true;
      final f = File(_file);
      await f.create(recursive: true);
      await f.writeAsString(json.encode(_users.map((x) => x.toJson()).toList()));
      return null;
    } catch (_) {
      return 'Invalid email or password.';
    }
  }

  Future<void> signOut() async {
    _signedIn = false;
    _currentUser = null;
    final f = File(_file);
    if (await f.exists()) await f.delete();
  }

  Future<void> _save() async {
    final f = File(_file);
    await f.create(recursive: true);
    await f.writeAsString(json.encode(_users.map((x) => x.toJson()).toList()));
  }

  bool hasDemo() => _users.any((u) => u.email == 'demo@bytebudget.io');
}
