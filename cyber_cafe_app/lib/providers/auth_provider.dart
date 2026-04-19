import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final user = await _authService.getCurrentUser();
    if (user != null) {
      _user = user;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final user = await _authService.login(email: email, password: password);
    if (user != null) {
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid email or password. Please try again.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    if (error == null) {
      final user = await _authService.getCurrentUser();
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = error;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> updateAddress(String address) async {
    if (_user == null) return;
    await _authService.updateAddress(_user!.id, address);
    _user!.address = address;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
