import 'package:flutter/material.dart';
import 'package:byte_budget/services/items_service.dart';
import 'package:byte_budget/services/order_service.dart';
import 'package:byte_budget/models/order_model.dart';

import 'package:byte_budget/screens/checkout/shipping_screen.dart';
import 'package:byte_budget/screens/onboarding/onboarding_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ItemsService().items;
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    return Scaffold(
      appBar: AppBar(title: const Text('To Pay')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Review your items and confirm payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1C3A6B)),
            ),
            const SizedBox(height: 12),
            const Text('Demo: items up to 10 shown. Tapping Pay sends you to shipping. Real checkout connects to a payment gateway in production.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final lines = items.take(10).map((it) => CartLine(itemId: it.id, name: it.name, emoji: it.emoji, unitPrice: it.basePrice, quantity: 1)).toList();
                final total = lines.fold(0.0, (a, l) => a + l.subtotal);
                final o = Order(id: orderId, userId: 'demo', status: 'paying', note: 'demo', total: total, createdAt: DateTime.now().toIso8601String(), lines: lines);
                OrderService().addOrder(o);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ShippingScreen()),
                );
              },
              icon: const Icon(Icons.payment, size: 18),
              label: const Text('Pay'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => OnboardingScreen(onComplete: () {})),
                );
              },
              child: const Text('Re-view Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}
