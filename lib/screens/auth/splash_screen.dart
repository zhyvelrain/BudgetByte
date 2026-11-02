import 'package:flutter/material.dart';
import 'package:byte_budget/screens/auth/login_screen.dart';

/// Landing screen that shows a brief splash, then redirects to either the
/// auth screen or the main flow depending on sign-in state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Services are loaded concurrently in main() before runApp(), so by the
    // time the splash appears there are no pending service calls to wait
    // for. Defer navigation off the UI thread so it doesn't block the
    // initial build.
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
  }

  void _navigate() {
    if (!mounted) return;
    // Services are already loaded by main() before runApp(), so no need
    // to wait again here. Navigate directly off the UI thread.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
