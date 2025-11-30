import 'package:flutter/material.dart';

// Model khusus untuk Auth Provider (Internal)
class AuthUser {
  final String username;
  final String email;
  final String phone;
  String password;

  AuthUser({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class AuthProvider with ChangeNotifier {
  final List<AuthUser> _registeredUsers = [];
  AuthUser? _currentUser;
  
  bool _isLoading = false;
  
  // Getters
  bool get isLoading => _isLoading;
  AuthUser? get currentUser => _currentUser;

  // LOGIN
  Future<bool> login(String identifier, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2)); // Simulasi loading

    try {
      // Cari user berdasarkan Email ATAU Username ATAU Phone
      final user = _registeredUsers.firstWhere(
        (u) => (u.email == identifier || u.username == identifier || u.phone == identifier) && u.password == password,
      );
      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  // REGISTER
  Future<bool> register(String username, String email, String phone, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2));

    // Cek duplikasi email
    final isExist = _registeredUsers.any((u) => u.email == email);
    if (isExist) {
      _setLoading(false);
      return false;
    }

    _registeredUsers.add(AuthUser(
      username: username,
      email: email,
      phone: phone,
      password: password,
    ));
    
    _setLoading(false);
    return true;
  }

  // RESET PASSWORD
  Future<bool> resetPassword(String username, String email, String newPassword) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2));

    try {
      final index = _registeredUsers.indexWhere(
        (u) => u.username == username && u.email == email
      );

      if (index != -1) {
        _registeredUsers[index].password = newPassword;
        notifyListeners();
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
