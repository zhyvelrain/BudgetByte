import 'package:flutter/material.dart';
import 'package:byte_budget/services/order_service.dart';
import 'package:byte_budget/screens/home/home_screen.dart';
import 'package:byte_budget/screens/orders/orders_screen.dart';
import 'package:byte_budget/screens/checkout/payment_screen.dart';
import 'package:byte_budget/screens/checkout/shipping_screen.dart';
import 'package:byte_budget/screens/orders/review_screen.dart';
import 'package:byte_budget/screens/add_cart_screen.dart';
import 'package:byte_budget/screens/cart/cart_screen.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderService().orders;
    final latest = orders.isNotEmpty ? orders.first : null;
    final orderId = latest?.id ?? 'ORD-empty';
    final lines = latest?.lines ?? [];
    final total = latest?.total ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: latest == null || lines.isEmpty
          ? const Center(child: Text('No receipt yet.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Confirmed', style: TextStyle(fontSize: 16, color: Colors.green[900])),
                        Text(
                          'Order #$orderId',
                          style: TextStyle(fontSize: 12, color: Colors.green[800]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your order has been placed and shipped.\nYou will receive it soon.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Items',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...lines.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${e.value.emoji} ${e.value.name}', style: const TextStyle(fontSize: 14)),
                        Text('₱${e.value.unitPrice.toStringAsFixed(2)} x ${e.value.quantity}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('₱${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C3A6B))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainContentAfterReceipt()),
                      );
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
    );
  }
}

class MainContentAfterReceipt extends StatelessWidget {
  const MainContentAfterReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeScreen(), const OrdersScreen(), const PaymentScreen(), const ShippingScreen(), const ReceiptScreen(), const ReviewScreen(), const AddCartScreen(), const CartScreen(),
    ];
    return Scaffold(body: IndexedStack(index: 0, children: tabs));
  }
}
