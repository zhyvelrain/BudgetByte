import 'package:flutter/material.dart';
import 'package:byte_budget/services/order_service.dart';
import 'package:byte_budget/screens/checkout/receipt_screen.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    final orders = OrderService().orders;
    final latest = orders.isNotEmpty ? orders.first : null;
    if (latest != null) {
      await OrderService().addOrder(latest.copyWith(status: 'shipping'));
    }
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ReceiptScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To Ship')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Confirm your shipping address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1C3A6B)),
            ),
            const SizedBox(height: 12),
            const Text('Enter your delivery address. In production this is validated and passed to your shipping carrier API.'),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Shipping address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.location_city),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading ? const CircularProgressIndicator() : const Text('Confirm Shipping'),
            ),
          ],
        ),
      ),
    );
  }
}
