import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'theme/bb_theme.dart';
import 'theme/bb_colors.dart';
import 'theme/bb_text.dart';
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/build_provider.dart';
import 'providers/shop_provider.dart';
import 'services/preferences_service.dart';
import 'services/component_data_service.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding/terms_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/builder/builder_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/saved_builds_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'widgets/connectivity_banner.dart';

/// Custom page route for smooth transitions
class _SmoothPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  _SmoothPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.08),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              ),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await PreferencesService.init();

  // Pre-load component data
  ComponentDataService.components; // triggers initialization

  runApp(const ByteBudgetApp());
}

class ByteBudgetApp extends StatefulWidget {
  const ByteBudgetApp({super.key});

  @override
  State<ByteBudgetApp> createState() => _ByteBudgetAppState();
}

class _ByteBudgetAppState extends State<ByteBudgetApp> {
  late final ThemeProvider _themeProvider;
  late final CartProvider _cartProvider;
  late final BuildProvider _buildProvider;
  final AuthService _authService = AuthService()..init();
  final ShopProvider _shopProvider = ShopProvider();
  late final Connectivity _connectivity;
  bool _showTerms = false;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _cartProvider = CartProvider();
    _buildProvider = BuildProvider();
    _connectivity = Connectivity();

    _initializeApp();
    _setupConnectivityListener();
  }

  Future<void> _initializeApp() async {
    await _themeProvider.init();
    await _cartProvider.init();
    await _buildProvider.init();
    await _shopProvider.init();

    // Check if terms accepted and onboarding completed
    final prefs = await PreferencesService.getPreferences();
    _showTerms = !prefs.termsAccepted;

    if (mounted) {
      setState(() {});
    }
  }

  void _setupConnectivityListener() {
      _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
        final isOnline = results.any((r) => r != ConnectivityResult.none);
        if (_isOnline != isOnline && mounted) {
          setState(() {
            _isOnline = isOnline;
          });
        }
      });

      // Check initial connectivity
      _connectivity.checkConnectivity().then((List<ConnectivityResult> results) {
        final isOnline = results.any((r) => r != ConnectivityResult.none);
        if (mounted) {
          setState(() {
            _isOnline = isOnline;
          });
        }
      });
    }

    void _onTermsAccept() async {
      final prefs = await PreferencesService.getPreferences();
      await PreferencesService.savePreferences(prefs.copyWith(termsAccepted: true));
      if (mounted) {
        setState(() {
          _showTerms = false;
        });
      }
    }

    void _onTermsDecline() {
      // Exit the app
      SystemNavigator.pop();
    }

    @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        ChangeNotifierProvider.value(value: _cartProvider),
        ChangeNotifierProvider.value(value: _buildProvider),
        ChangeNotifierProvider.value(value: _authService),
        ChangeNotifierProvider.value(value: _shopProvider),
      ],
      child: Consumer2<ThemeProvider, AuthService>(
        builder: (context, themeProvider, _, _) {
          return MaterialApp(
            title: 'ByteBudget',
            debugShowCheckedModeBanner: false,
            theme: BBTheme.light(),
            darkTheme: BBTheme.dark(),
            themeMode: themeProvider.themeMode,
            home: _buildAppRoot(),
            onGenerateRoute: _generateRoute,
          );
        },
      ),
    );
  }

  Widget _buildAppRoot() {
        if (!_themeProvider.isInitialized || !_cartProvider.isInitialized || !_buildProvider.isInitialized) {
          return _buildSplashScreen();
        }

        if (_showTerms) {
          return TermsScreen(onAccept: _onTermsAccept, onDecline: _onTermsDecline);
        }

    if (!_authService.signedIn) {
      return const LoginScreen();
    }

    return Stack(
      children: [
        const MainScreen(),
        if (!_isOnline)
          const ConnectivityBanner(),
      ],
    );
  }

  Widget _buildSplashScreen() {
      return Scaffold(
        backgroundColor: BBColors.nightBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: BrandAccents.electricGradient,
                                borderRadius: BorderRadius.circular(BBColors.radiusLg),
                                boxShadow: [
                                  BoxShadow(
                                    color: BrandAccents.electricBlueAt(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.memory_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
              const SizedBox(height: BBColors.padXL),
              Text(
                'ByteBudget',
                style: BBText.displayLarge(
                  size: 36,
                  color: BBColors.white,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: BBColors.padM),
              Text(
                'Your PC Build Companion',
                style: BBText.bodyLarge(
                  color: BBColors.nightTextSecondary,
                ),
              ),
              const SizedBox(height: BBColors.padXXL),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(BBColors.accentBlue),
                ),
              ),
            ],
          ),
        ),
      );
    }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
      // Handle deep links or specific routes with smooth transitions
      switch (settings.name) {
        case '/builder':
          return _SmoothPageRoute(child: const BuilderScreen(), settings: settings);
        case '/cart':
          return _SmoothPageRoute(child: const CartScreen(), settings: settings);
        case '/profile':
          return _SmoothPageRoute(child: const ProfileScreen(), settings: settings);
        case '/home':
          return _SmoothPageRoute(child: const HomeScreen(), settings: settings);
        case '/saved-builds':
          return _SmoothPageRoute(child: const SavedBuildsScreen(), settings: settings);
        case '/orders':
          return _SmoothPageRoute(child: const OrdersScreen(), settings: settings);
        default:
          return null;
      }
    }
  }
