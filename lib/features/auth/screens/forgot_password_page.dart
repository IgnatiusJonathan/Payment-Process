import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1426),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_reset, color: Colors.yellow, size: 40),
            const SizedBox(height: 10),
            const Text("Forgot Password", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Enter the email address and username for reset password.", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 30),

            _buildLabel("Username"),
            _buildTextField(controller: _usernameController, hint: "Enter Username"),

            _buildLabel("Email Address"),
            _buildTextField(controller: _emailController, hint: "Enter Email Address"),

            const Divider(color: Colors.grey, height: 40),
            
            _buildLabel("New Password"),
            _buildTextField(controller: _newPassController, hint: "Enter New Password", isPassword: true),

            _buildLabel("Confirm Password"),
            _buildTextField(controller: _confirmPassController, hint: "Confirm New Password", isPassword: true),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : () async {
                   if (_newPassController.text != _confirmPassController.text) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password baru tidak cocok!")));
                     return;
                   }

                   final provider = Provider.of<AuthProvider>(context, listen: false);
                   bool success = await provider.resetPassword(
                     _usernameController.text,
                     _emailController.text,
                     _newPassController.text
                   );

                   if (success && context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password berhasil direset! Silakan login.")));
                     Navigator.pop(context);
                   } else if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal! Username & Email tidak cocok.")));
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0096C7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    bool isPassword = false
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1C273A),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }
}