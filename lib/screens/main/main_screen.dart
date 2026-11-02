import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/build_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../home/home_screen.dart';
import '../builder/builder_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const BuilderScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, CartProvider, BuildProvider>(
      builder: (context, themeProvider, cartProvider, buildProvider, _) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            cartItemCount: cartProvider.itemCount,
          ),
        );
      },
    );
  }
}