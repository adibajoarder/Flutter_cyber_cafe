import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/drink.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../widgets/drink_card.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Drink> _allDrinks = [];
  List<Drink> _filteredDrinks = [];
  String _selectedCategory = 'All';
  final List<String> _categories = MockDataService.getCategories();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allDrinks = MockDataService.getDrinks();
    _filteredDrinks = _allDrinks;
  }

  void _filterDrinks(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchCtrl.text.toLowerCase();
    _filteredDrinks = _allDrinks.where((d) {
      final matchesCategory = _selectedCategory == 'All' || d.category == _selectedCategory;
      final matchesSearch = d.name.toLowerCase().contains(query) ||
          d.description.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, ${auth.user?.name.split(' ').first ?? 'Guest'} 👋',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'What would you like to drink?',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profile avatar
                  GestureDetector(
                    onTap: _showProfileSheet,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          auth.user?.name.isNotEmpty == true
                              ? auth.user!.name[0].toUpperCase()
                              : 'G',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextFormField(
                controller: _searchCtrl,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                onChanged: (v) => setState(() => _applyFilters()),
                decoration: InputDecoration(
                  hintText: 'Search drinks...',
                  hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38, size: 20),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.07),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            // Category chips
            SizedBox(
              height: 46,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => _filterDrinks(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                              )
                            : null,
                        color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                                  blurRadius: 10,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.white54,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Drinks grid
            Expanded(
              child: _filteredDrinks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded,
                              color: Colors.white24, size: 56),
                          const SizedBox(height: 12),
                          Text(
                            'No drinks found',
                            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: _filteredDrinks.length,
                      itemBuilder: (context, index) {
                        return DrinkCard(drink: _filteredDrinks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),

      // Floating Cart Button
      floatingActionButton: cart.itemCount > 0
          ? GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      '${cart.itemCount} items · \$${cart.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showProfileSheet() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A3E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                ),
              ),
              child: Center(
                child: Text(
                  auth.user?.name.isNotEmpty == true
                      ? auth.user!.name[0].toUpperCase()
                      : 'G',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              auth.user?.name ?? '',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              auth.user?.email ?? '',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
            ),
            if (auth.user?.phone.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                auth.user!.phone,
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
              ),
            ],
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await auth.logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.red.withValues(alpha: 0.15),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}