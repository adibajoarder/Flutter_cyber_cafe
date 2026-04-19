import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/payment_service.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final PaymentService _paymentService = PaymentService();
  String _selectedPayment = 'Credit / Debit Card';
  final _cardCtrl = TextEditingController();
  final _upiCtrl = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardCtrl.dispose();
    _upiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final methods = _paymentService.getPaymentMethods();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary card
            _sectionTitle('Order Summary'),
            const SizedBox(height: 12),
            _buildOrderSummary(cart),

            const SizedBox(height: 24),

            // Delivery address
            _sectionTitle('Delivery To'),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.location_on_rounded,
              title: cart.deliveryAddress,
              subtitle: auth.user?.name ?? '',
            ),

            const SizedBox(height: 24),

            // Payment method
            _sectionTitle('Payment Method'),
            const SizedBox(height: 12),
            ...methods.map((method) => _buildPaymentOption(method)),

            // Card number field
            if (_selectedPayment == 'Credit / Debit Card') ...[
              const SizedBox(height: 12),
              _buildPaymentField(
                controller: _cardCtrl,
                label: 'Card Number',
                hint: 'XXXX XXXX XXXX XXXX',
                icon: Icons.credit_card_rounded,
                keyboardType: TextInputType.number,
              ),
            ],

            // UPI ID field
            if (_selectedPayment == 'UPI / Mobile Pay') ...[
              const SizedBox(height: 12),
              _buildPaymentField(
                controller: _upiCtrl,
                label: 'UPI ID',
                hint: 'yourname@upi',
                icon: Icons.qr_code_rounded,
              ),
            ],

            const SizedBox(height: 24),

            // Price breakdown
            _sectionTitle('Price Details'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  _priceRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _priceRow('Delivery Charge', '\$${cart.deliveryCharge.toStringAsFixed(2)}'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Colors.white12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6C63FF),
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pay button
            GestureDetector(
              onTap: _isProcessing ? null : () => _processPayment(context, cart),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: _isProcessing
                      ? const LinearGradient(colors: [Color(0xFF555577), Color(0xFF555577)])
                      : const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                        ),
                  boxShadow: _isProcessing
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Center(
                  child: _isProcessing
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Processing Payment...',
                              style: GoogleFonts.poppins(
                                  color: Colors.white70, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Pay \$${cart.totalAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_rounded, color: Colors.white24, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Secured & encrypted payment',
                    style: GoogleFonts.poppins(color: Colors.white24, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: cart.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${item.quantity}x',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.drink.name,
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                  ),
                ),
                Text(
                  '\$${(item.drink.price * item.quantity).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C63FF), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle,
                    style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
                Text(title,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    final isSelected = _selectedPayment == method;
    IconData icon;
    switch (method) {
      case 'Credit / Debit Card':
        icon = Icons.credit_card_rounded;
        break;
      case 'UPI / Mobile Pay':
        icon = Icons.qr_code_rounded;
        break;
      default:
        icon = Icons.money_rounded;
    }
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected
              ? const Color(0xFF6C63FF).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF6C63FF) : Colors.white38, size: 20),
            const SizedBox(width: 12),
            Text(
              method,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF6C63FF), size: 20, key: ValueKey('checked'))
                  : const Icon(Icons.radio_button_unchecked_rounded,
                      color: Colors.white24, size: 20, key: ValueKey('unchecked')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  Future<void> _processPayment(BuildContext context, CartProvider cart) async {
    setState(() => _isProcessing = true);

    // Capture context-dependent objects BEFORE the async gap to satisfy
    // use_build_context_synchronously lint rule.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final total = cart.totalAmount;
    final address = cart.deliveryAddress;
    final paymentMethod = _selectedPayment;

    final success = await _paymentService.processPayment(
      amount: total,
      method: paymentMethod,
      cardNumber: _cardCtrl.text,
      upiId: _upiCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      cart.clearCart();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
            total: total,
            address: address,
            paymentMethod: paymentMethod,
          ),
        ),
        (route) => route.isFirst,
      );
    } else {
      setState(() => _isProcessing = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Payment failed. Please try again.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
