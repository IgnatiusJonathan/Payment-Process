import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _userName;

  // Getter untuk mengambil data dari UI
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;

  // Fungsi Simulasi Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    
    // Simulasi delay request ke server/backend
    await Future.delayed(const Duration(seconds: 2));

    // Validasi dummy (Nanti diganti dengan API Call yang asli)
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userName = "Mahasiswa Hebat"; // Contoh data user
      _setLoading(false);
      return true; // Login berhasil
    } else {
      _setLoading(false);
      return false; // Login gagal
    }
  }

  // Fungsi Simulasi Register
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    
    // Disini nanti logika kirim data ke Backend
    _isLoggedIn = true;
    _userName = name;
    
    _setLoading(false);
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Memberitahu UI untuk update tampilan
  }
}