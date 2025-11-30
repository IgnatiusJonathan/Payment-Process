import 'package:flutter/material.dart';

class CheckoutPaymentSection extends StatelessWidget {
  final String transactionType;
  final bool dalamProses;
  final VoidCallback? bayarTombol;

  const CheckoutPaymentSection({
    super.key,
    required this.transactionType,
    required this.dalamProses,
    required this.bayarTombol,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: bayarTombol,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        child: dalamProses
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'BAYAR ${transactionType == 'transfer' ? 'TRANSFER' : 'TOP-UP'}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
