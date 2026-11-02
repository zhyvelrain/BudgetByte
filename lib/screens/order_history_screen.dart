import 'package:flutter/material.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/brand_button.dart';
import '../../models/app_models.dart';
import '../../services/preferences_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History', style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600)),
      ),
      body: FutureBuilder<List<Order>>(
        future: PreferencesService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return _EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'No Orders Yet',
              subtitle: 'Your purchase history will appear here',
              actionText: 'Start Shopping',
              onAction: () {
                // Navigate to home
              },
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(BBColors.padL),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: BBColors.padM),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BBColors.padXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: BBColors.textMuted(context)),
            ),
            const SizedBox(height: BBColors.padXL),
            Text(title, style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600)),
            const SizedBox(height: BBColors.padS),
            Text(subtitle, style: BBTextResponsive.bodyLarge(context, color: BBColors.textMuted(context)), textAlign: TextAlign.center),
            const SizedBox(height: BBColors.padXL),
            BrandButton(text: actionText, icon: Icons.arrow_forward_rounded, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(order.status);

    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ${order.id}', style: BBTextResponsive.titleMedium(context, weight: FontWeight.w600)),
                    Text(_formatDate(order.createdAt), style: BBTextResponsive.caption(context)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(BBColors.radiusLg),
                ),
                child: Text(
                  order.status.label,
                  style: BBTextResponsive.labelSmall(context, color: statusColor, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: BBColors.padM),
          // Items preview
          ...order.items.take(3).map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                    borderRadius: BorderRadius.circular(BBColors.radiusSm),
                  ),
                  child: item.component.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(BBColors.radiusSm),
                          child: Image.asset(item.component.images.first, fit: BoxFit.cover),
                        )
                      : Icon(item.component.category.icon, size: 18, color: item.component.category.color),
                ),
                const SizedBox(width: BBColors.padM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.component.name, style: BBTextResponsive.bodySmall(context, weight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${item.selectedOptionValue ?? item.selectedOption ?? ''} • x${item.quantity}', style: BBTextResponsive.caption(context)),
                    ],
                  ),
                ),
                Text('\$${item.lineTotal.toStringAsFixed(2)}', style: BBTextResponsive.bodySmall(context, weight: FontWeight.w600)),
              ],
            ),
          )),
          if (order.items.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+ ${order.items.length - 3} more items',
                style: BBTextResponsive.caption(context, color: BBColors.accentBlue, weight: FontWeight.w500),
              ),
            ),
          const Divider(height: BBColors.padL),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${order.items.length} items', style: BBTextResponsive.bodyMedium(context)),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: BBTextResponsive.titleMedium(context, weight: FontWeight.w700, color: BBColors.accentBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
      switch (status) {
        case OrderStatus.pending:
          return BBColors.accentOrange;
        case OrderStatus.confirmed:
          return BBColors.accentBlue;
        case OrderStatus.shipped:
          return BBColors.catMonitor;
        case OrderStatus.delivered:
          return BBColors.accentGreen;
        case OrderStatus.cancelled:
          return BBColors.accentRed;
      }
    }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}