import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'theme/bb_theme.dart';
import 'theme/bb_colors.dart';
import 'theme/bb_text.dart';
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/build_provider.dart';
import 'services/preferences_service.dart';
import 'services/component_data_service.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/main/main_screen.dart';
import 'widgets/connectivity_banner.dart';

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
  late final Connectivity _connectivity;
  bool _showOnboarding = false;
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

    // Check if onboarding is completed
    final prefs = await PreferencesService.getPreferences();
    _showOnboarding = !prefs.onboardingCompleted;

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

  void _onOnboardingComplete() async {
    final prefs = await PreferencesService.getPreferences();
    await PreferencesService.savePreferences(prefs.copyWith(onboardingCompleted: true));
    if (mounted) {
      setState(() {
        _showOnboarding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        ChangeNotifierProvider.value(value: _cartProvider),
        ChangeNotifierProvider.value(value: _buildProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
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

    if (_showOnboarding) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
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
    // Handle deep links or specific routes if needed
    return null;
  }
}
