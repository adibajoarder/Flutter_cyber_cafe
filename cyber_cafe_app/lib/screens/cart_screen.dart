import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import 'checkout_screen.dart';

// Converted to StatefulWidget so the address TextEditingController
// survives rebuilds and the user's typing is not lost.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    // Initialise with whatever address is already in the cart provider
    final cart = Provider.of<CartProvider>(context, listen: false);
    _addressCtrl = TextEditingController(text: cart.deliveryAddress);
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

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
          'My Cart',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => _showClearDialog(context, cart),
              child: Text(
                'Clear',
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 13),
              ),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                // Delivery address section
                _buildDeliverySection(context, cart),

                // Items list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(cartItem: cart.items[index]);
                    },
                  ),
                ),

                // Price summary
                _buildPriceSummary(context, cart),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                color: Colors.white24, size: 50),
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some drinks to get started!',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                ),
              ),
              child: Text(
                'Browse Drinks',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(BuildContext context, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: Color(0xFF6C63FF), size: 18),
              const SizedBox(width: 6),
              Text(
                'Delivery Address',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressCtrl,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            onChanged: (v) => cart.setDeliveryAddress(v),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter your seat/table number or delivery address...',
              hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF6C63FF)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A3E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          _priceRow('Delivery Charge', '\$${cart.deliveryCharge.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6C63FF),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (cart.deliveryAddress.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a delivery address first',
                        style: GoogleFonts.poppins()),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.payment_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Proceed to Checkout',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  void _showClearDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Clear Cart?',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text('All items will be removed from your cart.',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              _addressCtrl.clear();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Clear', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}