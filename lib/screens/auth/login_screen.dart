import 'package:flutter/material.dart';
import 'package:byte_budget/services/auth_service.dart';
import 'package:byte_budget/services/theme_service.dart';
import 'package:byte_budget/widgets/bottom_nav_bar.dart';
import 'package:byte_budget/screens/home/home_screen.dart';
import 'package:byte_budget/screens/orders/orders_screen.dart';
import 'package:byte_budget/screens/checkout/payment_screen.dart';
import 'package:byte_budget/screens/checkout/shipping_screen.dart';
import 'package:byte_budget/screens/checkout/receipt_screen.dart';
import 'package:byte_budget/screens/orders/review_screen.dart';
import 'package:byte_budget/screens/add_cart_screen.dart';
import 'package:byte_budget/screens/cart/cart_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String _msg = '';
  int _tabIndex = 0;

  static const String demoEmail = 'demo@bytebudget.io';
  static const String demoPass = 'demo1234';

  void _switchTab(int i) => setState(() => _tabIndex = i);

  Future<void> _submit() async {
    if (!mounted) return;
    setState(() { _loading = true; _msg = ''; });
    if (_tabIndex == 0) {
      final err = await AuthService().signIn(email: _emailController.text.trim(), password: _passController.text);
      if (err == null) {
        _onLogin = () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainContent()));
        _navigateToHome();
      } else {
        setState(() => _msg = err);
      }
    } else {
      final err = await AuthService().signUp(email: _emailController.text.trim(), password: _passController.text, name: _nameController.text.trim());
      if (err.isEmpty) {
        _showMessage('Signed up! Please sign in.');
        _switchTab(0);
      } else {
        setState(() => _msg = err);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  VoidCallback? _onLogin;
  BuildContext? _currentContext;

  void _navigateToHome() {
    if (_onLogin != null) {
      _onLogin!();
      return;
    }
    debugPrint('ByteBudget: _navigateToHome called without callback');
  }

  void _showMessage(String m) {
    if (!mounted || _currentContext == null) return;
    ScaffoldMessenger.of(_currentContext!).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('ByteBudget'), actions: [
        IconButton(icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode), color: isDark ? Colors.white : Colors.black87, onPressed: () async {
          await ThemeService().toggle();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ThemeService().dark ? 'Dark mode on' : 'Light mode on')));
          }
        }),
      ]),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isDark ? [Color(0xFF1C3A6B), Color(0xFF2466D9)] : [Color(0xFFFFF3D6), Color(0xFFE3F0FF)]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AuthTabs(current: _tabIndex, onTap: _switchTab, isDark: isDark),
                const SizedBox(height: 16),
                TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), prefixIconColor: Color(0xFF3A80FF)), validator: (v) => v == null || v.isEmpty ? 'Enter your email' : null, autofillHints: const [AutofillHints.email]),
                const SizedBox(height: 12),
                TextFormField(controller: _passController, obscureText: _obscurePassword, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outlined), prefixIconColor: Color(0xFF3A80FF), suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))), validator: (v) => v == null || v.isEmpty ? 'Enter your password' : null),
                if (_tabIndex == 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outlined), prefixIconColor: Color(0xFF3A80FF)), validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null, autofillHints: const [AutofillHints.name]),
                  ),
                if (_msg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_msg, style: const TextStyle(color: Colors.red, fontSize: 13), textAlign: TextAlign.center),
                  ),
                const SizedBox(height: 12),
                SizedBox(height: 46, child: ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_tabIndex == 0 ? 'Sign In' : 'Sign Up'))),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  TextButton(onPressed: () => _switchTab(1), child: const Text("Don't have an account? Sign Up")),
                  TextButton(onPressed: () => _switchTab(0), child: const Text("Already have an account? Sign In")),
                  TextButton(onPressed: () => _showMessage('Reset link (demo)'), child: const Text('Forgot password?')),
                ]),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue[200]!)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline, size: 18, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text('Demo: $demoEmail / $demoPass', style: TextStyle(color: Colors.blue[700], fontSize: 12)),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(context).pushReplacementNamed('/onboarding'),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.book_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text('View Onboarding Guide', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTabs extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _AuthTabs({required this.current, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['Sign In', 'Sign Up'].map((t) {
        final i = t == 'Sign In' ? 0 : 1;
        return Expanded(
          child: RawMaterialButton(
            onPressed: () => onTap(i),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isDark ? Colors.white : Colors.blue[300]!)),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: i == current ? (isDark ? Colors.white : Color(0xFF3A80FF)) : Colors.transparent),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(t, style: TextStyle(color: i == current ? (isDark ? Colors.blue[900] : Colors.white) : (isDark ? Colors.white : Colors.blue[700]), fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  int _tabIndex = 0;
  final int _cartCount = 0;

  void _nav(int i) => setState(() => _tabIndex = i);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeScreen(), const OrdersScreen(), const PaymentScreen(), const ShippingScreen(), const ReceiptScreen(), const ReviewScreen(), const AddCartScreen(), const CartScreen(),
    ];
    return Scaffold(body: IndexedStack(index: _tabIndex, children: tabs), bottomNavigationBar: BottomNavBar(currentIndex: _tabIndex, onTap: _nav, cartCount: _cartCount));
  }
}
