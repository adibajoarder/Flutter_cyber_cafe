import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final double total;
  final String address;
  final String paymentMethod;

  const OrderConfirmationScreen({
    super.key,
    required this.total,
    required this.address,
    required this.paymentMethod,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderId =
        '#CC${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 64),
                ),
              ),

              const SizedBox(height: 32),

              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text(
                      'Order Placed! 🎉',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your drinks are being prepared',
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    // Order details card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Column(
                        children: [
                          _detailRow(
                            icon: Icons.receipt_long_rounded,
                            label: 'Order ID',
                            value: orderId,
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _detailRow(
                            icon: Icons.attach_money_rounded,
                            label: 'Amount Paid',
                            value: '\$${widget.total.toStringAsFixed(2)}',
                            valueColor: const Color(0xFF6C63FF),
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _detailRow(
                            icon: Icons.payment_rounded,
                            label: 'Payment',
                            value: widget.paymentMethod,
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _detailRow(
                            icon: Icons.location_on_rounded,
                            label: 'Delivery To',
                            value: widget.address,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Delivery status tracker
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statusStep(Icons.receipt_rounded, 'Confirmed', true),
                          _statusDivider(true),
                          _statusStep(Icons.local_cafe_rounded, 'Preparing', true),
                          _statusDivider(false),
                          _statusStep(Icons.delivery_dining_rounded, 'On Way', false),
                          _statusDivider(false),
                          _statusStep(Icons.check_circle_rounded, 'Done', false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
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
                          child: Text(
                            'Back to Menu',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 18),
        const SizedBox(width: 10),
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: valueColor ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _statusStep(IconData icon, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xFF6C63FF)
                : Colors.white.withValues(alpha: 0.08),
          ),
          child: Icon(icon,
              color: active ? Colors.white : Colors.white24, size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
              color: active ? Colors.white : Colors.white24, fontSize: 9),
        ),
      ],
    );
  }

  Widget _statusDivider(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: active
            ? const Color(0xFF6C63FF)
            : Colors.white.withValues(alpha: 0.08),
      ),
    );
  }
}
