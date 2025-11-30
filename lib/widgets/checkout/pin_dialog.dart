import 'package:flutter/material.dart';

class PinDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const PinDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Theme(
      data: ThemeData.dark().copyWith(
        dialogBackgroundColor: theme.colorScheme.tertiary,
        colorScheme: theme.colorScheme,
      ),
      child: AlertDialog(
        backgroundColor: theme.colorScheme.tertiary,
        title: Text(
          'Masukkan Password',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        content: TextField(
          obscureText: true,
          keyboardType: TextInputType.text,
          maxLength: 20,
          style: TextStyle(color: theme.colorScheme.onPrimary),
          decoration: InputDecoration(
            hintText: 'Masukkan Password anda',
            hintStyle: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.6)),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.primary),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }
}
