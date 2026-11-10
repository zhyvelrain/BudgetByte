import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../providers/shop_provider.dart';
import 'package:provider/provider.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_card.dart';
import '../../widgets/brand_button.dart';
import '../../widgets/peripheral_scene.dart';
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
        title: Text(
          'Cart',
          style: BBTextResponsive.headlineMedium(
            context,
            weight: FontWeight.w600,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.items.isNotEmpty) {
                return TextButton.icon(
                  icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                  label: Text(
                    'Clear',
                    style: BBTextResponsive.labelMedium(context),
                  ),
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

          return LayoutBuilder(
            builder: (context, constraints) {
              final receiptMaxHeight = (constraints.maxHeight * 0.46).clamp(
                190.0,
                380.0,
              );

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      // Items List
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            BBColors.padL,
                            BBColors.padL,
                            BBColors.padL,
                            BBColors.padS,
                          ),
                          itemCount: cart.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: BBColors.padM),
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return _CartItemCard(
                              item: item,
                              onQuantityChanged: (qty) =>
                                  cart.updateQuantity(item.id, qty),
                              onRemove: () => cart.removeItem(item.id),
                            );
                          },
                        ),
                      ),
                      // Receipt Summary. Capped and scrollable so short windows
                      // (or landscape phones) never push the checkout button off
                      // screen.
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: receiptMaxHeight,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [_ReceiptSummary(cart: cart)],
                        ),
                      ),
                      // Action Buttons
                      _CartActionBar(cart: cart),
                    ],
                  ),
                ),
              );
            },
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
        content: Text(
          'Are you sure you want to remove all items?',
          style: BBTextResponsive.bodyMedium(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: BBTextResponsive.labelMedium(context)),
          ),
          BrandButton.outline(
            text: 'Clear All',
            foregroundColor: BBColors.readable(context, BBColors.accentRed),
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
                gradient: isDark
                    ? BBColors.cardGradientDark
                    : BBColors.cardGradientLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 56,
                color: BBColors.readable(context, BBColors.accentBlue),
              ),
            ),
            const SizedBox(height: BBColors.padXL),
            Text(
              'Your cart is empty',
              style: BBTextResponsive.headlineMedium(
                context,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: BBColors.padS),
            Text(
              'Add components from the shop or build your custom PC',
              style: BBTextResponsive.bodyLarge(
                context,
                color: BBColors.textMuted(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBColors.padXL),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: BBColors.padM,
              runSpacing: BBColors.padM,
              children: [
                BrandButton(
                  text: 'Start Building',
                  icon: Icons.build_rounded,
                  onPressed: () => goToTab(context, 1),
                  variant: BrandButtonVariant.secondary,
                ),
                BrandButton(
                  text: 'Browse Shop',
                  icon: Icons.store_rounded,
                  onPressed: () => goToTab(context, 0),
                  variant: BrandButtonVariant.primary,
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
    final categoryColor = BBColors.readable(
      context,
      item.component.category.color,
    );
    final hasSale =
        item.option != null &&
        item.option!.originalPrice != null &&
        item.option!.price != null &&
        item.option!.originalPrice! > item.option!.price!;

    return BrandCard(
      padding: const EdgeInsets.all(BBColors.padM),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Below this width the quantity + price row no longer fits beside
          // the image, so it moves under the product details.
          final compact = constraints.maxWidth < 360;
          final imageSize = compact ? 64.0 : 80.0;

          final image = Container(
            width: imageSize,
            height: imageSize,
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
                        size: compact ? 28 : 36,
                        color: categoryColor,
                      ),
                    )
                  : Icon(
                      item.component.category.icon,
                      size: compact ? 28 : 36,
                      color: categoryColor,
                    ),
            ),
          );

          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.component.name,
                style: BBTextResponsive.bodyMedium(
                  context,
                  weight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      item.component.brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: BBTextResponsive.caption(context),
                    ),
                  ),
                  if (hasSale) ...[
                    const SizedBox(width: BBColors.padS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: BBColors.accentRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(BBColors.radiusSm),
                      ),
                      child: Text(
                        item.option!.discountLabel ?? 'Sale',
                        style: BBTextResponsive.labelSmall(
                          context,
                          color: BBColors.readable(context, BBColors.accentRed),
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (item.option?.colorHex != null) ...[
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse(
                            item.option!.colorHex!.replaceFirst('#', '0xFF'),
                          ),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? BBColors.nightBorder
                              : BBColors.dayBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      item.option?.name ??
                          item.selectedOptionValue ??
                          'Default',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: BBTextResponsive.bodySmall(
                        context,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );

          final quantity = Container(
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
                  icon: Icon(
                    Icons.remove_rounded,
                    size: 18,
                    color: BBColors.textMuted(context),
                  ),
                  onPressed: item.quantity > 1
                      ? () => onQuantityChanged(item.quantity - 1)
                      : null,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  tooltip: 'Decrease quantity',
                ),
                Text(
                  '${item.quantity}',
                  style: BBTextResponsive.bodyMedium(
                    context,
                    weight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: BBColors.readable(context, BBColors.accentBlue),
                  ),
                  onPressed: () => onQuantityChanged(item.quantity + 1),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  tooltip: 'Increase quantity',
                ),
              ],
            ),
          );

          final price = Text(
            context.money(item.lineTotal),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: BBTextResponsive.titleMedium(
              context,
              weight: FontWeight.w700,
              color: categoryColor,
            ),
          );

          final remove = IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: BBColors.readable(context, BBColors.accentRed),
              size: 22,
            ),
            onPressed: onRemove,
            tooltip: 'Remove',
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            padding: EdgeInsets.zero,
          );

          if (compact) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image,
                    const SizedBox(width: BBColors.padM),
                    Expanded(child: details),
                    remove,
                  ],
                ),
                const SizedBox(height: BBColors.padS),
                Row(
                  children: [
                    quantity,
                    const SizedBox(width: BBColors.padS),
                    Expanded(child: price),
                  ],
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              image,
              const SizedBox(width: BBColors.padM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    details,
                    const SizedBox(height: BBColors.padS),
                    Row(
                      children: [
                        quantity,
                        const SizedBox(width: BBColors.padS),
                        Expanded(child: price),
                      ],
                    ),
                  ],
                ),
              ),
              remove,
            ],
          );
        },
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
          Text(
            'Order Summary',
            style: BBTextResponsive.titleLarge(
              context,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: BBColors.padM),
          _ReceiptRow(
            label:
                'Subtotal (${cart.itemCount} ${cart.itemCount == 1 ? 'item' : 'items'})',
            value: context.money(cart.subtotal),
          ),
          _ReceiptRow(
            label: 'Shipping',
            value: cart.shipping == 0 ? 'Free' : context.money(cart.shipping),
            valueColor: cart.shipping == 0
                ? BBColors.readable(context, BBColors.accentGreen)
                : null,
          ),
          _ReceiptRow(
            label: 'Tax (${(CartProvider.taxRate * 100).round()}%)',
            value: context.money(cart.tax),
          ),
          const Divider(height: BBColors.padL),
          _ReceiptRow(
            label: 'Total',
            value: context.money(cart.total),
            isTotal: true,
          ),
          if (cart.amountToFreeShipping > 0 && cart.items.isNotEmpty) ...[
            const SizedBox(height: BBColors.padM),
            Container(
              padding: const EdgeInsets.all(BBColors.padM),
              decoration: BoxDecoration(
                color: BBColors.accentOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(BBColors.radiusMd),
                border: Border.all(
                  color: BBColors.accentOrange.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping_rounded,
                    size: 18,
                    color: BBColors.readable(context, BBColors.accentOrange),
                  ),
                  const SizedBox(width: BBColors.padS),
                  Expanded(
                    child: Text(
                      'Add ${context.money(cart.amountToFreeShipping)} more for free shipping!',
                      style: BBTextResponsive.bodySmall(
                        context,
                        color: BBColors.readable(
                          context,
                          BBColors.accentOrange,
                        ),
                        weight: FontWeight.w500,
                      ),
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
                  ? BBTextResponsive.titleMedium(
                      context,
                      weight: FontWeight.w600,
                    )
                  : BBTextResponsive.bodyMedium(context),
            ),
          ),
          const SizedBox(width: BBColors.padS),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isTotal
                  ? BBTextResponsive.displaySmall(
                      context,
                      weight: FontWeight.w700,
                      color: valueColor ?? BBColors.accentBlue,
                    )
                  : BBTextResponsive.bodyMedium(
                      context,
                      weight: FontWeight.w600,
                      color: valueColor,
                    ),
            ),
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
      padding: const EdgeInsets.fromLTRB(
        BBColors.padL,
        BBColors.padM,
        BBColors.padL,
        BBColors.padL,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: BrandButton.primary(
          text: 'Checkout (${context.money(cart.total)})',
          icon: Icons.credit_card_rounded,
          onPressed: cart.items.isNotEmpty
              ? () => _showCheckoutDialog(context)
              : null,
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

  late final String _initialName;
  late final String _initialEmail;
  late final String _initialAddress;
  late final String _initialCity;
  late final String _initialZip;

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
    _initialName = _nameController.text;
    _initialEmail = _emailController.text;
    _initialAddress = _addressController.text;
    _initialCity = _cityController.text;
    _initialZip = _zipController.text;
  }

  /// Only ask before closing when the shopper would actually lose something.
  /// Prefilled values don't count — they are already saved on the device.
  bool get _hasEnteredData {
    if (_step > 0) return true;
    return _nameController.text.trim() != _initialName.trim() ||
        _emailController.text.trim() != _initialEmail.trim() ||
        _addressController.text.trim() != _initialAddress.trim() ||
        _cityController.text.trim() != _initialCity.trim() ||
        _zipController.text.trim() != _initialZip.trim() ||
        _cardController.text.isNotEmpty ||
        _expiryController.text.isNotEmpty ||
        _cvvController.text.isNotEmpty;
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
    final media = MediaQuery.of(context);
    // Dialog adds the keyboard inset itself; cap the card to what is actually
    // left so the footer never gets pushed off screen.
    final availableHeight =
        media.size.height - media.viewInsets.bottom - (BBColors.padL * 2);
    final maxHeight = availableHeight.clamp(200.0, 640.0);

    return PopScope(
      // Let the system back gesture close a pristine checkout immediately, but
      // route it through the discard confirmation once anything was entered.
      canPop: !_hasEnteredData,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _requestCancel();
      },
      child: Dialog(
        insetPadding: const EdgeInsets.all(BBColors.padL),
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 520, maxHeight: maxHeight),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isDark ? BBColors.nightBg : BBColors.dayBg,
              borderRadius: BorderRadius.circular(BBColors.radiusXl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BBColors.padL,
                    vertical: BBColors.padM,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? BBColors.nightDivider
                            : BBColors.dayDivider,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _StepIndicator(
                        label: 'Shipping',
                        step: 0,
                        currentStep: _step,
                      ),
                      _StepConnector(step: 0, currentStep: _step),
                      _StepIndicator(
                        label: 'Payment',
                        step: 1,
                        currentStep: _step,
                      ),
                      _StepConnector(step: 1, currentStep: _step),
                      _StepIndicator(
                        label: 'Review',
                        step: 2,
                        currentStep: _step,
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      BBColors.padL,
                      BBColors.padM,
                      BBColors.padL,
                      BBColors.padL,
                    ),
                    child: Form(
                      key: _formKey,
                      child: _step == 0
                          ? _buildShippingStep()
                          : _step == 1
                          ? _buildPaymentStep()
                          : _buildReviewStep(),
                    ),
                  ),
                ),
                // Actions: the primary action is always visible, with Back and
                // Cancel on their own row so three buttons never crowd a phone.
                Container(
                  padding: const EdgeInsets.all(BBColors.padL),
                  decoration: BoxDecoration(
                    color: isDark ? BBColors.nightSurface : BBColors.daySurface,
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? BBColors.nightDivider
                            : BBColors.dayDivider,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BrandButton(
                        text: _step == 2 ? 'Place Order' : 'Continue',
                        icon: _step == 2
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        onPressed: _processing ? null : _handleNext,
                        isLoading: _processing,
                        fullWidth: true,
                      ),
                      const SizedBox(height: BBColors.padS),
                      Row(
                        children: [
                          if (_step > 0) ...[
                            Expanded(
                              child: BrandButton.outline(
                                text: 'Back',
                                icon: Icons.arrow_back_rounded,
                                onPressed: _processing
                                    ? null
                                    : () => setState(() => _step--),
                              ),
                            ),
                            const SizedBox(width: BBColors.padS),
                          ],
                          Expanded(
                            child: TextButton.icon(
                              onPressed: _processing ? null : _requestCancel,
                              icon: const Icon(Icons.close_rounded, size: 18),
                              label: const Text('Cancel'),
                              style: TextButton.styleFrom(
                                foregroundColor: BBColors.textSecondary(
                                  context,
                                ),
                                minimumSize: const Size(0, 44),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestCancel() async {
    if (_processing) return;
    if (!_hasEnteredData) {
      Navigator.of(context).pop();
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Discard checkout?',
          style: BBTextResponsive.titleLarge(dialogContext),
        ),
        content: Text(
          'Your shipping and payment details will be lost. Items in your cart are kept.',
          style: BBTextResponsive.bodyMedium(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: BBColors.readable(
                dialogContext,
                BBColors.accentRed,
              ),
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard == true && mounted) Navigator.of(context).pop();
  }

  Widget _buildShippingStep() {
    final cityField = TextFormField(
      controller: _cityController,
      decoration: const InputDecoration(
        labelText: 'City',
        prefixIcon: Icon(Icons.location_city_rounded),
      ),
      autofillHints: const [AutofillHints.addressCity],
      validator: (v) => (v?.trim().length ?? 0) < 2 ? 'Enter your city.' : null,
    );
    final zipField = TextFormField(
      controller: _zipController,
      decoration: const InputDecoration(
        labelText: 'ZIP Code',
        prefixIcon: Icon(Icons.pin_rounded),
      ),
      keyboardType: TextInputType.number,
      autofillHints: const [AutofillHints.postalCode],
      validator: (v) => RegExp(r'^\d{4,10}$').hasMatch(v?.trim() ?? '')
          ? null
          : 'Use 4–10 digits.',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Information',
          style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600),
        ),
        const SizedBox(height: BBColors.padS),
        Text(
          'Where should we send your order?',
          style: BBTextResponsive.bodyMedium(context),
        ),
        const SizedBox(height: BBColors.padM),
        Container(
          padding: const EdgeInsets.all(BBColors.padM),
          decoration: BoxDecoration(
            color: BBColors.accentGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(BBColors.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_shipping_rounded,
                size: 18,
                color: BBColors.readable(context, BBColors.accentGreen),
              ),
              const SizedBox(width: BBColors.padS),
              Expanded(
                child: Text(
                  'Ships in 1–2 business days · Arrives in 3–5 days',
                  style: BBTextResponsive.bodySmall(
                    context,
                    color: BBColors.readable(context, BBColors.accentGreen),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: BBColors.padL),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_rounded),
          ),
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          validator: AuthService.validateName,
        ),
        const SizedBox(height: BBColors.padM),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_rounded),
          ),
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
          validator: (v) =>
              (v?.trim().length ?? 0) < 5 ? 'Enter your street address.' : null,
        ),
        const SizedBox(height: BBColors.padM),
        LayoutBuilder(
          builder: (context, constraints) {
            // Two side-by-side fields get cramped on narrow phones.
            if (constraints.maxWidth < 340) {
              return Column(
                children: [
                  cityField,
                  const SizedBox(height: BBColors.padM),
                  zipField,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: cityField),
                const SizedBox(width: BBColors.padM),
                Expanded(child: zipField),
              ],
            );
          },
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
            title: Text(
              'Save address for future orders',
              style: BBTextResponsive.bodyMedium(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600),
        ),
        const SizedBox(height: BBColors.padS),
        Text(
          'Demo checkout — no real payment will be processed.',
          style: BBTextResponsive.bodyMedium(context),
        ),
        const SizedBox(height: BBColors.padL),
        TextFormField(
          controller: _cardController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            prefixIcon: Icon(Icons.credit_card_rounded),
            hintText: '16-digit card number',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          validator: (v) {
            final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
            if (digits.isEmpty) return 'Required';
            return digits.length == 16 ? null : 'Enter all 16 digits';
          },
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  LengthLimitingTextInputFormatter(5),
                ],
                validator: (v) {
                  final text = v?.trim() ?? '';
                  if (text.isEmpty) return 'Required';
                  return RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(text)
                      ? null
                      : 'Use MM/YY';
                },
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (v) {
                  final text = v?.trim() ?? '';
                  if (text.isEmpty) return 'Required';
                  return RegExp(r'^\d{3,4}$').hasMatch(text)
                      ? null
                      : 'Invalid CVV';
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: BBColors.padM),
        Row(
          children: [
            Icon(
              Icons.lock_rounded,
              size: 14,
              color: BBColors.readable(context, BBColors.accentGreen),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Your details stay on this device and are never sent to a server.',
                style: BBTextResponsive.caption(context),
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
        Text(
          'Review Order',
          style: BBTextResponsive.titleLarge(context, weight: FontWeight.w600),
        ),
        const SizedBox(height: BBColors.padS),
        Text(
          'Check your finished setup and delivery details before paying.',
          style: BBTextResponsive.bodyMedium(context),
        ),
        const SizedBox(height: BBColors.padM),
        PeripheralScene(
          slots: SceneSlot.fromCart(widget.cart.items),
          height: 150,
          showControls: false,
          autoRotate: false,
        ),
        const SizedBox(height: BBColors.padM),
        // Shipping info
        BrandCard(
          padding: const EdgeInsets.all(BBColors.padM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping To',
                style: BBTextResponsive.labelMedium(
                  context,
                  color: BBColors.accentBlue,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: BBColors.padS),
              Text(
                _nameController.text,
                style: BBTextResponsive.bodyMedium(
                  context,
                  weight: FontWeight.w600,
                ),
              ),
              Text(
                _emailController.text,
                style: BBTextResponsive.bodySmall(context),
              ),
              Text(
                '${_addressController.text}, ${_cityController.text} ${_zipController.text}',
                style: BBTextResponsive.bodySmall(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: BBColors.padM),
        Text(
          '${widget.cart.itemCount} ${widget.cart.itemCount == 1 ? 'item' : 'items'}',
          style: BBTextResponsive.labelMedium(context, weight: FontWeight.w600),
        ),
        const SizedBox(height: BBColors.padS),
        // Items
        ...widget.cart.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: BBColors.padS),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${item.component.name} (${item.option?.name ?? item.selectedOptionValue ?? 'Default'}) x${item.quantity}',
                    style: BBTextResponsive.bodySmall(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: BBColors.padS),
                Text(
                  context.money(item.lineTotal),
                  style: BBTextResponsive.bodySmall(
                    context,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        _ReceiptRow(
          label: 'Subtotal',
          value: context.money(widget.cart.subtotal),
        ),
        _ReceiptRow(
          label: 'Shipping',
          value: widget.cart.shipping == 0
              ? 'Free'
              : context.money(widget.cart.shipping),
          valueColor: widget.cart.shipping == 0
              ? BBColors.readable(context, BBColors.accentGreen)
              : null,
        ),
        _ReceiptRow(
          label: 'Tax (${(CartProvider.taxRate * 100).round()}%)',
          value: context.money(widget.cart.tax),
        ),
        const Divider(height: BBColors.padL),
        _ReceiptRow(
          label: 'Total',
          value: context.money(widget.cart.total),
          isTotal: true,
        ),
      ],
    );
  }

  void _handleNext() {
    if (_processing) return;
    if (!_formKey.currentState!.validate()) return;

    if (_step == 2) {
      _placeOrder();
    } else {
      setState(() => _step++);
    }
  }

  Future<void> _placeOrder() async {
    if (_processing) return;
    setState(() => _processing = true);

    final navigator = Navigator.of(context);
    final rootContext = navigator.context;
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final address = Address(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      street: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zipCode: _zipController.text.trim(),
    );
    final digits = _cardController.text.replaceAll(RegExp(r'\D'), '');
    final last4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : digits;
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
      paymentMethod: PaymentMethod(type: 'card', last4: last4),
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

  const _StepIndicator({
    required this.label,
    required this.step,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = step <= currentStep;
    final isCurrent = step == currentStep;
    final activeLabel = BBColors.readable(context, BBColors.accentBlue);

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isActive
                  ? BBColors.accentBlue
                  : Theme.of(context).dividerColor,
              shape: BoxShape.circle,
            ),
            child: isActive && step < currentStep
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: BBColors.dayTextPrimary,
                  )
                : Center(
                    child: Text(
                      '${step + 1}',
                      style: BBTextResponsive.labelSmall(
                        context,
                        color: isActive
                            ? BBColors.dayTextPrimary
                            : BBColors.textMuted(context),
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: BBTextResponsive.caption(
              context,
              color: isActive ? activeLabel : BBColors.textMuted(context),
              weight: isCurrent ? FontWeight.w600 : FontWeight.normal,
            ),
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
        color: step < currentStep
            ? BBColors.accentBlue
            : Theme.of(context).dividerColor,
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
    final maxHeight = (MediaQuery.sizeOf(context).height - 48).clamp(
      240.0,
      640.0,
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(BBColors.padL),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 460, maxHeight: maxHeight),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? BBColors.nightBg : BBColors.dayBg,
            borderRadius: BorderRadius.circular(BBColors.radiusXl),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(BBColors.padXL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success animation container
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: BBColors.accentGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 52,
                    color: BBColors.readable(context, BBColors.accentGreen),
                  ),
                ),
                const SizedBox(height: BBColors.padL),
                Text(
                  'Order Confirmed!',
                  style: BBTextResponsive.headlineLarge(
                    context,
                    weight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BBColors.padS),
                Text(
                  'Your order has been placed successfully',
                  style: BBTextResponsive.bodyLarge(
                    context,
                    color: BBColors.textMuted(context),
                  ),
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
                      _ReceiptRow(
                        label: 'Total Paid',
                        value: context.money(total),
                        isTotal: true,
                        valueColor: BBColors.readable(
                          context,
                          BBColors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: BBColors.padL),
                BrandButton(
                  text: 'Continue Shopping',
                  icon: Icons.store_rounded,
                  onPressed: onContinue,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
