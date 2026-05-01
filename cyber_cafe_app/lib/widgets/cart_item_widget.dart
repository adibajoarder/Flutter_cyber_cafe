import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: Key(cartItem.drink.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cart.removeFromCart(cartItem.drink.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.red, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cartItem.drink.image,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                    ),
                  ),
                  child: const Icon(Icons.local_cafe_rounded, color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name & price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.drink.name,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${cartItem.drink.price.toStringAsFixed(2)} each',
                    style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Subtotal: \$${(cartItem.drink.price * cartItem.quantity).toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF6C63FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            // Quantity controls
            Column(
              children: [
                _iconBtn(
                  icon: Icons.add_rounded,
                  onTap: () => cart.incrementQuantity(cartItem.drink.id),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    '${cartItem.quantity}',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                _iconBtn(
                  icon: Icons.remove_rounded,
                  onTap: () => cart.decrementQuantity(cartItem.drink.id),
                  isRemove: cartItem.quantity == 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool isRemove = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: isRemove
              ? const LinearGradient(colors: [Colors.red, Color(0xFFFF6584)])
              : const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                ),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
