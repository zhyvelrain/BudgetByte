import 'package:flutter/material.dart';
import 'package:byte_budget/theme/k_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  static const int tabCount = 8;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabCount,
        separatorBuilder: (_, _) => const SizedBox(width: 4),
        itemBuilder: (context, i) {
          final isActive = i == currentIndex;
          return _TabRowItem(
            index: i,
            isActive: isActive,
            isDark: isDark,
            cartCount: cartCount,
            onTap: () => onTap(i),
          );
        },
      ),
    );
  }
}

class _TabRowItem extends StatelessWidget {
  final int index;
  final bool isActive;
  final bool isDark;
  final int cartCount;
  final VoidCallback onTap;

  const _TabRowItem({
    required this.index,
    required this.isActive,
    required this.isDark,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = BottomNavTab.values;
    final tab = tabs[index];
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: _buildRow(tab),
      ),
    );
  }

  Row _buildRow(BottomNavTab tab) {
    final IconData icon = _icon(tab, isDark);
    final String label = _label(tab);
    final badge = _badgeFor(tab);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 22,
          color: isActive ? _activeColor(tab) : (isDark ? KColors.cream700 : KColors.inkFaint),
        ),
        if (badge != null)
          ...[
            const SizedBox(width: 4),
            badge,
          ],
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? _activeTextColor(tab) : (isDark ? KColors.cream700 : KColors.inkFaint),
          ),
        ),
      ],
    );
  }

  IconData _icon(BottomNavTab t, bool dark) {
    switch (t) {
      case BottomNavTab.home:
        return Icons.home_outlined;
      case BottomNavTab.orders:
        return Icons.shopping_bag_outlined;
      case BottomNavTab.pay:
        return Icons.payment_outlined;
      case BottomNavTab.ship:
        return Icons.local_shipping_outlined;
      case BottomNavTab.receive:
        return Icons.receipt_long_outlined;
      case BottomNavTab.review:
        return Icons.star_outline;
      case BottomNavTab.addToCart:
        return Icons.shopping_cart_outlined;
      case BottomNavTab.cart:
        return Icons.shopping_cart_outlined;
    }
  }

  String _label(BottomNavTab t) {
    switch (t) {
      case BottomNavTab.home:
        return 'Home';
      case BottomNavTab.orders:
        return 'All Orders';
      case BottomNavTab.pay:
        return 'To Pay';
      case BottomNavTab.ship:
        return 'To Ship';
      case BottomNavTab.receive:
        return 'To Receive';
      case BottomNavTab.review:
        return 'To Review';
      case BottomNavTab.addToCart:
        return 'Add Cart';
      case BottomNavTab.cart:
        return 'Cart';
    }
  }

  Color _activeColor(BottomNavTab t) {
    switch (t) {
      case BottomNavTab.cart:
      case BottomNavTab.addToCart:
        return KColors.blue500;
      default:
        return KColors.richBlue;
    }
  }

  Color _activeTextColor(BottomNavTab t) {
    switch (t) {
      case BottomNavTab.cart:
      case BottomNavTab.addToCart:
        return KColors.blue500;
      default:
        return KColors.richBlue;
    }
  }

  Widget? _badgeFor(BottomNavTab t) {
    switch (t) {
      case BottomNavTab.cart:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(color: KColors.blue500, shape: BoxShape.circle),
          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
          child: Text(
            '$cartCount',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: KColors.white),
          ),
        );
      case BottomNavTab.addToCart:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(color: KColors.blue500, shape: BoxShape.circle),
          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
          child: const Text(
            '10',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: KColors.white),
          ),
        );
      default:
        return null;
    }
  }
}

enum BottomNavTab { home, orders, pay, ship, receive, review, addToCart, cart }
