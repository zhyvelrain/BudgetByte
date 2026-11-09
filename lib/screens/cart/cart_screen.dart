import 'package:flutter/material.dart';
import '../../providers/shop_provider.dart';
import 'package:provider/provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/brand_button.dart';
import '../../models/app_models.dart';
import '../../providers/cart_provider.dart';
import '../../services/preferences_service.dart';
import '../../services/auth_service.dart';
import '../main/main_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600)),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.items.isNotEmpty) {
                return TextButton.icon(
                  icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                  label: Text('Clear', style: BBTextResponsive.labelMedium(context)),
                  onPressed: () => _showClearDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return _EmptyCartState();
          }

          return Column(
            children: [
              // Items List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(BBColors.padL),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: BBColors.padM),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _CartItemCard(
                      item: item,
                      onQuantityChanged: (qty) => cart.updateQuantity(item.id, qty),
                      onRemove: () => cart.removeItem(item.id),
                    );
                  },
                ),
              ),
              // Receipt Summary
              _ReceiptSummary(cart: cart),
              // Action Buttons
              _CartActionBar(cart: cart),
            ],
          );
        },
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart', style: BBTextResponsive.titleLarge(context)),
        content: Text('Are you sure you want to remove all items?', style: BBTextResponsive.bodyMedium(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: BBTextResponsive.labelMedium(context)),
          ),
          BrandButton.outline(
            text: 'Clear All',
            foregroundColor: BBColors.accentRed,
            onPressed: () {
              context.read<CartProvider>().clearAll();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyCartState extends StatelessWidget {
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
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 56,
                color: BBColors.textMuted(context),
              ),
            ),
            const SizedBox(height: BBColors.padXL),
            Text(
              'Your cart is empty',
              style: BBTextResponsive.headlineMedium(context, weight: FontWeight.w600),
            ),
            const SizedBox(height: BBColors.padS),
            Text(
              'Add components from the shop or build your custom PC',
              style: BBTextResponsive.bodyLarge(context, color: BBColors.textMuted(context)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBColors.padXL),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: BBColors.padM,
              runSpacing: BBColors.padM,
              children: [
                BrandButton.outline(
                  text: 'Start Building',
                  icon: Icons.build_rounded,
                  onPressed: () => goToTab(context, 1),
                ),
                BrandButton(
                  text: 'Browse Shop',
                  icon: Icons.store_rounded,
                  onPressed: () => goToTab(context, 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final void Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = item.component.category.color;

    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? BBColors.nightSurface : BBColors.daySurface,
              borderRadius: BorderRadius.circular(BBColors.radiusMd),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(BBColors.radiusMd),
              child: item.image != null
                  ? Image.asset(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        item.component.category.icon,
                        size: 36,
                        color: categoryColor,
                      ),
                    )
                  : Icon(
                      item.component.category.icon,
                      size: 36,
                      color: categoryColor,
                    ),
            ),
          ),
          const SizedBox(width: BBColors.padM),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.component.name,
                        style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.option != null && 
                        item.option!.originalPrice != null && 
                        item.option!.price != null &&
                        item.option!.originalPrice! > item.option!.price!)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: BBColors.accentRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(BBColors.radiusSm),
                        ),
                        child: Text(
                          item.option!.discountLabel ?? 'Sale',
                          style: BBTextResponsive.labelSmall(context, color: BBColors.accentRed, weight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                Text(item.component.brand, style: BBTextResponsive.caption(context)),
                const SizedBox(height: 4),
                // Selected option
                Row(
                  children: [
                    if (item.option?.colorHex != null) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(int.parse(item.option!.colorHex!.replaceFirst('#', '0xFF'))),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? BBColors.nightBorder : BBColors.dayBorder,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        item.option?.name ?? item.selectedOptionValue ?? 'Default',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BBTextResponsive.bodySmall(context, weight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: BBColors.padS),
                // Quantity & Price
                Row(
                  children: [
                    // Quantity selector
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                        borderRadius: BorderRadius.circular(BBColors.radiusMd),
                        border: Border.all(
                          color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_rounded, size: 18, color: BBColors.textMuted(context)),
                            onPressed: item.quantity > 1 ? () => onQuantityChanged(item.quantity - 1) : null,
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                          Text(
                            '${item.quantity}',
                            style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_rounded, size: 18, color: BBColors.accentBlue),
                            onPressed: () => onQuantityChanged(item.quantity + 1),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: BBColors.padS),
                    // Line total
                    Expanded(
                      child: Text(
                        context.money(item.lineTotal),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BBTextResponsive.titleMedium(context, weight: FontWeight.w700, color: categoryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove button
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: BBColors.accentRed, size: 22),
            onPressed: onRemove,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}

class _ReceiptSummary extends StatelessWidget {
  final CartProvider cart;

  const _ReceiptSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(BBColors.padL),
      decoration: BoxDecoration(
        color: isDark ? BBColors.nightSurface : BBColors.daySurface,
        border: Border(
          top: BorderSide(
            color: isDark ? BBColors.nightDivider : BBColors.dayDivider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
          const SizedBox(height: BBColors.padM),
          _ReceiptRow(
            label: 'Subtotal (${cart.itemCount} items)',
            value: context.money(cart.subtotal),
          ),
          _ReceiptRow(
            label: 'Shipping',
            value: cart.shipping == 0 ? 'Free' : context.money(cart.shipping),
            valueColor: cart.shipping == 0 ? BBColors.accentGreen : null,
          ),
          _ReceiptRow(
            label: 'Tax (10%)',
            value: context.money(cart.tax),
          ),
          const Divider(height: BBColors.padL),
          _ReceiptRow(
            label: 'Total',
            value: context.money(cart.total),
            isTotal: true,
          ),
          if (cart.subtotal < 100 && cart.items.isNotEmpty) ...[
            const SizedBox(height: BBColors.padM),
            Container(
              padding: const EdgeInsets.all(BBColors.padM),
              decoration: BoxDecoration(
                color: BBColors.accentOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
                border: Border.all(color: BBColors.accentOrange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping_rounded, size: 18, color: BBColors.accentOrange),
                  const SizedBox(width: BBColors.padS),
                  Expanded(
                    child: Text(
                      'Add ${context.money((100 - cart.subtotal))} more for free shipping!',
                      style: BBTextResponsive.bodySmall(context, color: BBColors.accentOrange, weight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: isTotal
                  ? BBTextResponsive.titleMedium(context, weight: FontWeight.w600)
                  : BBTextResponsive.bodyMedium(context),
            ),
          ),
          const SizedBox(width: BBColors.padS),
          Text(
            value,
            style: isTotal
                ? BBTextResponsive.displaySmall(context, weight: FontWeight.w700, color: valueColor ?? BBColors.accentBlue)
                : BBTextResponsive.bodyMedium(context, weight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _CartActionBar extends StatelessWidget {
  final CartProvider cart;

  const _CartActionBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(BBColors.padL, BBColors.padM, BBColors.padL, BBColors.padL),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: BrandButton.primary(
          text: 'Checkout (${context.money(cart.total)})',
          icon: Icons.credit_card_rounded,
          onPressed: cart.items.isNotEmpty ? () => _showCheckoutDialog(context) : null,
          fullWidth: true,
        ),
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CheckoutDialog(cart: cart),
    );
  }
}

class _CheckoutDialog extends StatefulWidget {
  final CartProvider cart;

  const _CheckoutDialog({required this.cart});

  @override
  State<_CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<_CheckoutDialog> {
  int _step = 0; // 0 = shipping, 1 = payment, 2 = review
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveInfo = true;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    // Prefill from the last saved address, falling back to the signed-in account.
    final saved = PreferencesService.getAddress();
    final user = context.read<AuthService>().currentUser;
    _nameController.text = saved?.name ?? user?.name ?? '';
    _emailController.text = saved?.email ?? user?.email ?? '';
    _addressController.text = saved?.street ?? '';
    _cityController.text = saved?.city ?? '';
    _zipController.text = saved?.zipCode ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      insetPadding: const EdgeInsets.all(BBColors.padL),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: isDark ? BBColors.nightBg : BBColors.dayBg,
          borderRadius: BorderRadius.circular(BBColors.radiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Step indicator
            Container(
              padding: const EdgeInsets.all(BBColors.padL),
              decoration: BoxDecoration(
                color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(BBColors.radiusXl)),
              ),
              child: Row(
                children: [
                  _StepIndicator(label: 'Shipping', step: 0, currentStep: _step),
                  _StepConnector(step: 0, currentStep: _step),
                  _StepIndicator(label: 'Payment', step: 1, currentStep: _step),
                  _StepConnector(step: 1, currentStep: _step),
                  _StepIndicator(label: 'Review', step: 2, currentStep: _step),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(BBColors.padXL),
                child: Form(
                  key: _formKey,
                  child: _step == 0 ? _buildShippingStep() : _step == 1 ? _buildPaymentStep() : _buildReviewStep(),
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(BBColors.padL),
              decoration: BoxDecoration(
                color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(BBColors.radiusXl)),
              ),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: BrandButton.outline(
                        text: 'Back',
                        onPressed: _processing ? null : () => setState(() => _step--),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: BBColors.padM),
                  Expanded(
                    flex: _step > 0 ? 1 : 2,
                    child: BrandButton(
                      text: _step == 2 ? 'Place Order' : 'Continue',
                      icon: _step == 2 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                      onPressed: _processing ? null : _handleNext,
                      isLoading: _processing,
                      fullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Information', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
        const SizedBox(height: BBColors.padS),
        Text('Where should we send your order?', style: BBTextResponsive.bodyMedium(context)),
        const SizedBox(height: BBColors.padL),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_rounded)),
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          validator: AuthService.validateName,
        ),
        const SizedBox(height: BBColors.padM),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_rounded)),
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          validator: AuthService.validateEmail,
        ),
        const SizedBox(height: BBColors.padM),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Street address',
            hintText: 'House no., street, barangay',
            prefixIcon: Icon(Icons.home_rounded),
          ),
          autofillHints: const [AutofillHints.fullStreetAddress],
          validator: (v) => (v?.trim().length ?? 0) < 5 ? 'Enter your street address.' : null,
        ),
        const SizedBox(height: BBColors.padM),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City', prefixIcon: Icon(Icons.location_city_rounded)),
                autofillHints: const [AutofillHints.addressCity],
                validator: (v) => (v?.trim().length ?? 0) < 2 ? 'Enter your city.' : null,
              ),
            ),
            const SizedBox(width: BBColors.padM),
            Expanded(
              child: TextFormField(
                controller: _zipController,
                decoration: const InputDecoration(labelText: 'ZIP Code', prefixIcon: Icon(Icons.pin_rounded)),
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.postalCode],
                validator: (v) => RegExp(r'^\d{4,10}$').hasMatch(v?.trim() ?? '') ? null : 'Use 4–10 digits.',
              ),
            ),
          ],
        ),
        const SizedBox(height: BBColors.padM),
        Material(
          type: MaterialType.transparency,
          child: CheckboxListTile(
            value: _saveInfo,
            onChanged: (v) => setState(() => _saveInfo = v ?? false),
            activeColor: BBColors.accentBlue,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Save address for future orders', style: BBTextResponsive.bodyMedium(context)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
        const SizedBox(height: BBColors.padS),
        Text('Your payment is secured with encryption', style: BBTextResponsive.bodyMedium(context)),
        const SizedBox(height: BBColors.padL),
        TextFormField(
          controller: _cardController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            prefixIcon: Icon(Icons.credit_card_rounded),
            hintText: '1234 5678 9012 3456',
          ),
          keyboardType: TextInputType.number,
          validator: (v) => v?.isEmpty == true ? 'Required' : (v!.replaceAll(' ', '').length == 16 ? null : 'Invalid card'),
        ),
        const SizedBox(height: BBColors.padM),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'MM/YY',
                  hintText: '12/28',
                ),
                keyboardType: TextInputType.datetime,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: BBColors.padM),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (v) => v?.isEmpty == true ? 'Required' : (v!.length == 3 ? null : 'Invalid CVV'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Order', style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600)),
        const SizedBox(height: BBColors.padL),
        // Shipping info
        BrandCard(
          padding: const EdgeInsets.all(BBColors.padM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shipping To', style: BBTextResponsive.labelMedium(context, color: BBColors.accentBlue, weight: FontWeight.w600)),
              const SizedBox(height: BBColors.padS),
              Text(_nameController.text, style: BBTextResponsive.bodyMedium(context, weight: FontWeight.w600)),
              Text(_emailController.text, style: BBTextResponsive.bodySmall(context)),
              Text('${_addressController.text}, ${_cityController.text} ${_zipController.text}', style: BBTextResponsive.bodySmall(context)),
            ],
          ),
        ),
        const SizedBox(height: BBColors.padM),
        // Items
        ...widget.cart.items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: BBColors.padS),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${item.component.name} (${item.option?.name ?? item.selectedOptionValue ?? 'Default'}) x${item.quantity}',
                  style: BBTextResponsive.bodySmall(context),
                ),
              ),
              Text(context.money(item.lineTotal), style: BBTextResponsive.bodySmall(context, weight: FontWeight.w600)),
            ],
          ),
        )),
        const Divider(),
        _ReceiptRow(label: 'Subtotal', value: context.money(widget.cart.subtotal)),
        _ReceiptRow(label: 'Shipping', value: widget.cart.shipping == 0 ? 'Free' : context.money(widget.cart.shipping)),
        _ReceiptRow(label: 'Tax (10%)', value: context.money(widget.cart.tax)),
        const Divider(height: BBColors.padL),
        _ReceiptRow(label: 'Total', value: context.money(widget.cart.total), isTotal: true),
      ],
    );
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    if (_step == 2) {
      _placeOrder();
    } else {
      setState(() => _step++);
    }
  }

  void _placeOrder() async {
    setState(() => _processing = true);

    final navigator = Navigator.of(context);
    final rootContext = navigator.context;
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 1));

    final address = Address(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      street: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zipCode: _zipController.text.trim(),
    );
    final order = Order(
      id: 'BB-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(widget.cart.items),
      subtotal: widget.cart.subtotal,
      tax: widget.cart.tax,
      shipping: widget.cart.shipping,
      total: widget.cart.total,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      shippingAddress: address,
      paymentMethod: PaymentMethod(
        type: 'card',
        last4: _cardController.text.replaceAll(' ', '').substring(12),
      ),
    );

    await PreferencesService.addOrder(order);
    if (_saveInfo) await PreferencesService.saveAddress(address);
    await widget.cart.clear();

    navigator.pop(); // Close checkout
    if (!rootContext.mounted) return;
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (dialogContext) => _PurchaseSuccessDialog(
        orderId: order.id,
        total: order.total,
        onContinue: () => goToTab(dialogContext, 0),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final int step;
  final int currentStep;

  const _StepIndicator({required this.label, required this.step, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isActive = step <= currentStep;
    final isCurrent = step == currentStep;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isActive ? BBColors.accentBlue : Theme.of(context).dividerColor,
              shape: BoxShape.circle,
            ),
            child: isActive && step < currentStep
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Center(
                    child: Text(
                      '${step + 1}',
                      style: BBTextResponsive.labelSmall(context, color: isActive ? Colors.white : BBColors.textMuted(context), weight: FontWeight.w600),
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: BBTextResponsive.caption(context, color: isActive ? BBColors.accentBlue : BBColors.textMuted(context), weight: isCurrent ? FontWeight.w600 : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final int step;
  final int currentStep;

  const _StepConnector({required this.step, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 28),
        color: step < currentStep ? BBColors.accentBlue : Theme.of(context).dividerColor,
      ),
    );
  }
}

class _PurchaseSuccessDialog extends StatelessWidget {
  final String orderId;
  final double total;
  final VoidCallback onContinue;

  const _PurchaseSuccessDialog({
    required this.orderId,
    required this.total,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(BBColors.padXXL),
        decoration: BoxDecoration(
          color: isDark ? BBColors.nightBg : BBColors.dayBg,
          borderRadius: BorderRadius.circular(BBColors.radiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success animation container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: BBColors.accentGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, size: 56, color: BBColors.accentGreen),
            ),
            const SizedBox(height: BBColors.padXL),
            Text(
              'Order Confirmed!',
              style: BBTextResponsive.headlineLarge(context, weight: FontWeight.w700),
            ),
            const SizedBox(height: BBColors.padS),
            Text(
              'Your order has been placed successfully',
              style: BBTextResponsive.bodyLarge(context, color: BBColors.textMuted(context)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBColors.padL),
            BrandCard(
              variant: BrandCardVariant.defaultCard,
              padding: const EdgeInsets.all(BBColors.padL),
              child: Column(
                children: [
                  _ReceiptRow(label: 'Order ID', value: orderId),
                  const SizedBox(height: BBColors.padS),
                  _ReceiptRow(label: 'Total Paid', value: context.money(total), isTotal: true, valueColor: BBColors.accentGreen),
                ],
              ),
            ),
            const SizedBox(height: BBColors.padXL),
            BrandButton(
              text: 'Continue Shopping',
              icon: Icons.store_rounded,
              onPressed: onContinue,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}