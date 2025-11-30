import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart'; 
import '../../../screens/home_screen.dart'; 
import '../../../models/user.dart' as real_user; 

import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return flutter.Scaffold(
      backgroundColor: const Color(0xFF0B1426),
      appBar: flutter.AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
            },
            child: const Text("Create Account", style: TextStyle(color: Color(0xFF0096C7), fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Log In to Phantom Wallet",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Use the registered email and password to log in to your account",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 40),

            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text("Email Address / Phone Number", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            
            // Input Email 
            flutter.TextField(
              controller: _identifierController,
              style: const TextStyle(color: Colors.white),
              decoration: flutter.InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C273A),
                hintText: "Enter email or phone",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text("Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),

            // Input Password 
            flutter.TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              style: const TextStyle(color: Colors.white),
              decoration: flutter.InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C273A),
                hintText: "Enter password",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF0096C7))),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : () async {
                  final provider = Provider.of<AuthProvider>(context, listen: false);
                  
                  if (_identifierController.text.isEmpty || _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mohon isi semua data")));
                    return;
                  }

                  bool success = await provider.login(_identifierController.text, _passwordController.text);
                  
                  if (success && context.mounted) {
              
                    final userForHome = real_user.User(
                      userId: 1, 
                      username: provider.currentUser?.username ?? "User",
                      email: provider.currentUser?.email ?? "email@test.com", 
                      password: _passwordController.text,
                      totalSaldo: 0, 
                      isLoggedIn: true,
                    );

                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => HomeScreen(user: userForHome))
                    );
                  } else if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Gagal! Cek email/password.")));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0096C7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Log In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
