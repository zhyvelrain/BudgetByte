import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../home/home_screen.dart';
import '../builder/builder_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

/// Selected bottom tab: 0 home, 1 builder, 2 cart, 3 profile.
final mainTab = ValueNotifier<int>(0);

/// Close any pushed screens and switch to a bottom tab.
void goToTab(BuildContext context, int index) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  mainTab.value = index;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _screens = [
    HomeScreen(),
    BuilderScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    mainTab.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: mainTab,
      builder: (context, index, _) => Scaffold(
        body: IndexedStack(
          index: index,
          children: [
            for (var i = 0; i < _screens.length; i++)
              // Keep off-screen tabs alive, but stop their tickers so hidden
              // 3D previews and loading animations don't burn frames.
              TickerMode(enabled: i == index, child: _screens[i]),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: index,
          onTap: (i) => mainTab.value = i,
          cartItemCount: context.watch<CartProvider>().itemCount,
        ),
      ),
    );
  }
}
