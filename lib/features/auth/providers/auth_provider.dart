import 'package:flutter/material.dart';
import '../../../database/database.dart';
import '../../../database/user_repository.dart';

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
  final Database db;
  late final UserRepository _userRepo;

  final List<AuthUser> _registeredUsers = []; 
  AuthUser? _currentUser;
  bool _isLoading = false;

  AuthProvider(this.db) {
    _userRepo = UserRepository(db);
  }

  bool get isLoading => _isLoading;
  AuthUser? get currentUser => _currentUser;

  Future<bool> login(String identifier, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      final userMap = await _userRepo.getUserByIdentifier(identifier);
      
      if (userMap != null) {
        final dbPassword = userMap['password'] as String;
        if (dbPassword == password) {
          _currentUser = AuthUser(
            username: userMap['username'] as String,
            email: userMap['email'] as String? ?? '',
            phone: userMap['phone'] as String? ?? '',
            password: dbPassword,
          );
          _setLoading(false);
          return true;
        }
      }
      
      _setLoading(false);
      return false;
    } catch (e) {
      print("Login error: $e");
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String username, String email, String phone, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      final existingUser = await _userRepo.getUserByIdentifier(email);
      if (existingUser != null) {
        _setLoading(false);
        return false;
      }
      
      final existingPhone = await _userRepo.getUserByIdentifier(phone);
      if (existingPhone != null) {
        _setLoading(false);
        return false;
      }

      await _userRepo.createUser(username, password, email, phone);

      _registeredUsers.add(AuthUser(
        username: username,
        email: email,
        phone: phone,
        password: password,
      ));
      
      _setLoading(false);
      return true;
    } catch (e) {
      print("Register error: $e");
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String username, String email, String newPassword) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      final userMap = await _userRepo.getUser(username);
      if (userMap != null && userMap['email'] == email) {

        _setLoading(false);
        return false; 
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

  Future<void> setLoggedIn(String username) async {
    try {
      final userMap = await _userRepo.getUser(username);
      if (userMap != null) {
        _currentUser = AuthUser(
          username: userMap['username'] as String,
          email: userMap['email'] as String? ?? '',
          phone: userMap['phone'] as String? ?? '',
          password: userMap['password'] as String,
        );
        notifyListeners();
      }
    } catch (e) {
      print("setLoggedIn error: $e");
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
} // barusan saya perbaiki kesalahan spasi kecil disini
}
