import 'package:flutter/material.dart';
import 'package:byte_budget/services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _orders = OrderService().orders;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = _orders;
    return Scaffold(
      appBar: AppBar(title: const Text('All Orders')),
      body: orders.isEmpty
          ? Center(child: Text('No orders yet.', style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[600])))
          : ListView.separated(
              itemBuilder: (BuildContext context, int i) {
                final o = orders[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(o.status.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor(o.status))),
                            Text(o.createdAt.substring(0, 10), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.shopping_cart, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text('${o.lines.length} items', style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text('\$${o.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemCount: orders.length,
            ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'pending': return Colors.orange;
      case 'paying': return Colors.blue;
      case 'shipped': return Colors.blue[700]!;
      case 'received': return Colors.green[700]!;
      case 'review': return Colors.purple;
      default: return Colors.grey;
    }
  }
}
