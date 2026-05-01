import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _loggedInKey = 'logged_in_user_id';

  // Get all registered users from local storage
  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];
    final List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.map((u) => UserModel.fromJson(u)).toList();
  }

  // Save users list to local storage
  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_usersKey, encoded);
  }

  // Register a new user
  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final users = await _getUsers();
    final exists = users.any((u) => u.email == email.trim().toLowerCase());
    if (exists) return 'An account with this email already exists.';

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      phone: phone.trim(),
    );

    users.add(newUser);
    await _saveUsers(users);
    await _setLoggedIn(newUser.id);
    return null; // null = success
  }

  // Login with email and password
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    try {
      final user = users.firstWhere(
        (u) =>
            u.email == email.trim().toLowerCase() && u.password == password,
      );
      await _setLoggedIn(user.id);
      return user;
    } catch (_) {
      return null;
    }
  }

  // Logout the current user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }

  // Get currently logged in user
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_loggedInKey);
    if (userId == null) return null;

    final users = await _getUsers();
    try {
      return users.firstWhere((u) => u.id == userId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _setLoggedIn(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInKey, userId);
  }

  // Update user address
  Future<void> updateAddress(String userId, String address) async {
    final users = await _getUsers();
    final idx = users.indexWhere((u) => u.id == userId);
    if (idx >= 0) {
      users[idx].address = address;
      await _saveUsers(users);
    }
  }
}