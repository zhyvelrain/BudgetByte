import 'package:flutter/material.dart';
import 'package:byte_budget/services/order_service.dart';
import 'package:byte_budget/screens/checkout/receipt_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderService().orders;
    final latest = orders.isNotEmpty ? orders.first : null;
    final lines = latest?.lines ?? [];
    final total = latest?.total ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('To Review')),
      body: (latest == null || lines.isEmpty)
          ? const Center(child: Text('No order to review.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Order #', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(latest.id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.receipt, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('Items', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
                          const Divider(),
                          ...lines.asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${e.value.emoji} ${e.value.name} x ${e.value.quantity}', style: const TextStyle(fontSize: 13)),
                                Text('\$${(e.value.unitPrice * e.value.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Status', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(latest.status.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (lines.isEmpty) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const ReceiptScreen()),
                      );
                    },
                    child: const Text('Confirm Order'),
                  ),
                ],
              ),
            ),
    );
  }
}
