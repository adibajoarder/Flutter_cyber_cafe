import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Login fields
  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  // Register fields
  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regPhoneCtrl = TextEditingController();
  final _regFormKey = GlobalKey<FormState>();

  bool _obscureLoginPass = true;
  bool _obscureRegPass = true;
  bool _loginLoading = false;
  bool _registerLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Clear errors when switching tabs so register errors don't show on login
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.clearError();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    _regPhoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D0D1A), Color(0xFF1A1A3E), Color(0xFF0D0D1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.local_cafe_rounded, color: Colors.white, size: 38),
              ),
              const SizedBox(height: 16),
              Text(
                'Cyber Café',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                    ),
                  ),
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Login'),
                    Tab(text: 'Register'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildRegisterForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final auth = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _loginEmailCtrl,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v!.isEmpty ? 'Enter your email' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _loginPassCtrl,
              label: 'Password',
              icon: Icons.lock_outline,
              obscure: _obscureLoginPass,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureLoginPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.white54,
                ),
                onPressed: () => setState(() => _obscureLoginPass = !_obscureLoginPass),
              ),
              validator: (v) => v!.isEmpty ? 'Enter your password' : null,
            ),
            const SizedBox(height: 8),
            if (auth.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        auth.errorMessage!,
                        style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 28),
            _buildGradientButton(
              label: 'Login',
              isLoading: _loginLoading,
              onTap: () async {
                if (!_loginFormKey.currentState!.validate()) return;
                final auth = Provider.of<AuthProvider>(context, listen: false);
                auth.clearError();
                setState(() => _loginLoading = true);
                final success = await auth.login(
                  _loginEmailCtrl.text.trim(),
                  _loginPassCtrl.text,
                );
                if (mounted) setState(() => _loginLoading = false);
                if (success && mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _tabController.animateTo(1),
              child: Text(
                "Don't have an account? Register",
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    final auth = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: _regFormKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _regNameCtrl,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _regEmailCtrl,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v!.isEmpty) return 'Enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _regPhoneCtrl,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Enter your phone number' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _regPassCtrl,
              label: 'Password',
              icon: Icons.lock_outline,
              obscure: _obscureRegPass,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureRegPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.white54,
                ),
                onPressed: () => setState(() => _obscureRegPass = !_obscureRegPass),
              ),
              validator: (v) {
                if (v!.isEmpty) return 'Enter a password';
                if (v.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 8),
            if (auth.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        auth.errorMessage!,
                        style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 28),
            _buildGradientButton(
              label: 'Create Account',
              isLoading: _registerLoading,
              onTap: () async {
                if (!_regFormKey.currentState!.validate()) return;
                final auth = Provider.of<AuthProvider>(context, listen: false);
                auth.clearError();
                setState(() => _registerLoading = true);
                final success = await auth.register(
                  name: _regNameCtrl.text.trim(),
                  email: _regEmailCtrl.text.trim(),
                  password: _regPassCtrl.text,
                  phone: _regPhoneCtrl.text.trim(),
                );
                if (mounted) setState(() => _registerLoading = false);
                if (success && mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _tabController.animateTo(0),
              child: Text(
                'Already have an account? Login',
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white54),
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
              : Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
