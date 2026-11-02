import 'package:flutter/material.dart';
import '../theme/bb_colors.dart';
import '../theme/bb_text.dart';

/// Connectivity banner shown when offline
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(
            top: 48, // Below status bar
            left: BBColors.padL,
            right: BBColors.padL,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: BBColors.padL,
            vertical: BBColors.padM,
          ),
          decoration: BoxDecoration(
            color: BBColors.warning.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(BBColors.radiusLg),
            boxShadow: [
              BoxShadow(
                color: BBColors.warning.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: isDark ? BBColors.nightBg : BBColors.dayTextPrimary,
                size: 20,
              ),
              const SizedBox(width: BBColors.padM),
              Expanded(
                child: Text(
                  'You\'re offline. Some features may be limited.',
                  style: BBText.labelMedium(
                    color: isDark ? BBColors.nightBg : BBColors.dayTextPrimary,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                color: isDark ? BBColors.nightBg : BBColors.dayTextPrimary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}