import 'package:flutter/material.dart';
import '../theme/bb_colors.dart';
import '../theme/bb_text.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartItemCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.cartItemCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? BBColors.nightSurface.withValues(alpha: 0.95)
            : BBColors.daySurface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: BBColors.elevationLg,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BBColors.padM,
            vertical: BBColors.padS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_rounded,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.build_rounded,
                activeIcon: Icons.build_rounded,
                label: 'Builder',
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart_rounded,
                label: 'Cart',
                onTap: onTap,
                badgeCount: cartItemCount,
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final ValueChanged<int> onTap;
  final int? badgeCount;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = currentIndex == index;
    final activeColor = BBColors.accentBlue;
    final inactiveColor = isDark ? BBColors.nightTextMuted : BBColors.dayTextMuted;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(BBColors.radiusLg),
          splashColor: activeColor.withValues(alpha: 0.1),
          highlightColor: activeColor.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: BBColors.animFast,
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: BBColors.padS,
              vertical: BBColors.padS,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedSwitcher(
                      duration: BBColors.animFast,
                      child: Icon(
                        isSelected ? activeIcon : icon,
                        key: ValueKey(isSelected),
                        size: 26,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                    ),
                    // Badge
                    if (badgeCount != null && badgeCount! > 0)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: AnimatedContainer(
                          duration: BBColors.animFast,
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: BBColors.danger,
                            borderRadius: BorderRadius.circular(BBColors.radiusFull),
                            border: Border.all(
                              color: isDark ? BBColors.nightBg : BBColors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: BBColors.danger.withValues(alpha: 0.4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              badgeCount! > 99 ? '99+' : badgeCount.toString(),
                              style: BBText.labelSmall(
                                color: Colors.white,
                                weight: FontWeight.w700,
                                size: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: BBColors.animFast,
                  style: BBText.labelSmall(
                    color: isSelected ? activeColor : inactiveColor,
                    weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(label),
                ),
                // Active indicator
                AnimatedContainer(
                  duration: BBColors.animFast,
                  margin: const EdgeInsets.only(top: 4),
                  height: 3,
                  width: isSelected ? 24 : 0,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(BBColors.radiusFull),
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