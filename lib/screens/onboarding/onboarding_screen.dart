import 'package:flutter/material.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_button.dart';

/// Onboarding slides data
final List<_OnboardingSlideData> _onboardingSlides = [
  _OnboardingSlideData(
    title: 'Welcome to ByteBudget',
    description: 'Your ultimate PC peripheral companion. Shop, compare, and build your dream setup all in one place.',
    icon: Icons.memory_rounded,
    accentColor: BBColors.accentBlue,
    gradient: BrandAccents.electricGradient,
  ),
  _OnboardingSlideData(
    title: 'Curated Components',
    description: 'Hand-picked keyboards, mice, monitors, audio gear, and cameras from top brands. Quality guaranteed.',
    icon: Icons.inventory_2_rounded,
    accentColor: BBColors.catKeyboard,
    gradient: LinearGradient(
      colors: [BBColors.catKeyboard, BBColors.catKeyboard.withValues(alpha: 0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _OnboardingSlideData(
    title: 'Build Your Setup',
    description: 'Mix and match components with our PC Builder. See real-time pricing, compatibility, and create your perfect build.',
    icon: Icons.build_rounded,
    accentColor: BBColors.catMouse,
    gradient: LinearGradient(
      colors: [BBColors.catMouse, BBColors.catMouse.withValues(alpha: 0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _OnboardingSlideData(
    title: 'Smart Shopping',
    description: 'Track prices, save favorites, and get notified on deals. Your cart syncs across devices seamlessly.',
    icon: Icons.shopping_cart_rounded,
    accentColor: BBColors.catMonitor,
    gradient: LinearGradient(
      colors: [BBColors.catMonitor, BBColors.catMonitor.withValues(alpha: 0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _OnboardingSlideData(
    title: 'Ready to Build?',
    description: 'Join thousands of PC enthusiasts. Start building your dream setup today!',
    icon: Icons.rocket_launch_rounded,
    accentColor: BBColors.accentOrange,
    gradient: LinearGradient(
      colors: [BBColors.accentOrange, BBColors.accentOrange.withValues(alpha: 0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
];

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: BBColors.animNormal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingSlides.length - 1) {
      _pageController.nextPage(
        duration: BBColors.animNormal,
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? BrandAccents.darkSurfaceGradient : BrandAccents.lightSurfaceGradient,
            ),
          ),
          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingSlides.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _animationController.reset();
              _animationController.forward();
            },
            itemBuilder: (context, index) {
              final slide = _onboardingSlides[index];
              return _OnboardingPage(
                slide: slide,
                fadeAnimation: _fadeAnimation,
                slideAnimation: _slideAnimation,
              );
            },
          ),
          // Bottom indicators and buttons
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(BBColors.padXL),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingSlides.length,
                        (index) => AnimatedContainer(
                          duration: BBColors.animFast,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _onboardingSlides[_currentPage].accentColor
                                : (isDark ? BBColors.nightDivider : BBColors.dayDivider),
                            borderRadius: BorderRadius.circular(BBColors.radiusFull),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: BBColors.padXL),
                    // Next/Get Started button
                    SizedBox(
                      width: double.infinity,
                      child: BrandButton(
                        text: _currentPage == _onboardingSlides.length - 1
                            ? 'Get Started'
                            : 'Next',
                        onPressed: _nextPage,
                        gradient: _onboardingSlides[_currentPage].gradient,
                        icon: _currentPage == _onboardingSlides.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.arrow_forward_rounded,
                        iconPosition: IconPosition.trailing,
                      ),
                    ),
                    if (_currentPage > 0) ...[
                      const SizedBox(height: BBColors.padM),
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: BBTextResponsive.labelLarge(context, color: BBColors.textMuted(context)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlideData {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Gradient gradient;

  const _OnboardingSlideData({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.gradient,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingSlideData slide;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const _OnboardingPage({
    required this.slide,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: BBColors.padXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Icon with gradient background
            FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: slide.gradient,
                    borderRadius: BorderRadius.circular(BBColors.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: slide.accentColor.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    slide.icon,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: BBColors.padXXL),
            // Title
            FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: BBTextResponsive.displayLarge(context, size: 28, weight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: BBColors.padL),
            // Description
            FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: BBTextResponsive.bodyLarge(
                    context,
                    color: isDark ? BBColors.nightTextSecondary : BBColors.dayTextSecondary,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 3),
            // Decorative elements
            FadeTransition(
              opacity: fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == 1 ? 16 : 10,
                    height: 4,
                    decoration: BoxDecoration(
                      color: index == 1
                          ? slide.accentColor
                          : (isDark ? BBColors.nightDivider : BBColors.dayDivider),
                      borderRadius: BorderRadius.circular(BBColors.radiusFull),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: BBColors.padXL),
          ],
        ),
      ),
    );
  }
}
