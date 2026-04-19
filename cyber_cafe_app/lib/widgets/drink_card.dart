import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/drink.dart';
import '../providers/cart_provider.dart';

class DrinkCard extends StatefulWidget {
  final Drink drink;
  const DrinkCard({super.key, required this.drink});

  @override
  State<DrinkCard> createState() => _DrinkCardState();
}

class _DrinkCardState extends State<DrinkCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _bounceCtrl;
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _bounceCtrl.reverse();
  void _onTapUp(_) => _bounceCtrl.forward();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final inCart = cart.isInCart(widget.drink.id);
    final qty = cart.quantityOf(widget.drink.id);

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () => _bounceCtrl.forward(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: inCart
                  ? const Color(0xFF6C63FF).withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drink image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.black12,
                      child: Image.network(
                        widget.drink.image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: const Center(
                            child: Icon(Icons.local_cafe_rounded, color: Colors.white54, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.drink.isPopular)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6584),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '⭐ Popular',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),

              // Info — compact, no Expanded/Spacer so price stays near image
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.drink.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.drink.category,
                      style: GoogleFonts.poppins(
                          color: Colors.white38, fontSize: 10),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.drink.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF6C63FF),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Add / Qty control
                        inCart
                            ? Row(
                                children: [
                                  _iconBtn(
                                    Icons.remove_rounded,
                                    () => cart.decrementQuantity(widget.drink.id),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Text(
                                      '$qty',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                  _iconBtn(
                                    Icons.add_rounded,
                                    () => cart.addToCart(widget.drink),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: () => cart.addToCart(widget.drink),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                                    ),
                                  ),
                                  child: const Icon(Icons.add_rounded,
                                      color: Colors.white, size: 18),
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
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}