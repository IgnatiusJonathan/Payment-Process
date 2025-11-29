import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/checkout/checkout_info.dart';
import '../widgets/checkout/checkout_timer.dart';
import '../widgets/checkout/checkout_payment.dart';
import '../widgets/checkout/pin_dialog.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String paymentType;
  final double amount;
  final String transactionType;

  const CheckoutScreen({
    super.key,
    required this.paymentType,
    required this.amount,
    required this.transactionType,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int waktuMundur = 600;
  bool _dalamProses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: Text(
          'Checkout - ${widget.transactionType.toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckoutInfoSection(
              paymentType: widget.paymentType,
              amount: widget.amount,
              transactionType: widget.transactionType,
            ),
            const SizedBox(height: 24),
            CheckoutTimerSection(waktuMundur: waktuMundur),
            const SizedBox(height: 24),
            CheckoutPaymentSection(
              transactionType: widget.transactionType,
              dalamProses: _dalamProses,
              bayarTombol: _dalamProses ? null : _showPinDialog,
            ),
          ],
        ),
      ),
    );
  }

  void _showPinDialog() {
    showDialog(
      context: context,
      builder: (context) => PinDialog(onConfirm: _prosesTransaksi),
    );
  }

  Future<void> _prosesTransaksi() async {
    if (_dalamProses) return;
    
    setState(() => _dalamProses = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (context.mounted) {
        Navigator.of(context).pop();
        _suksesPopup();
      }
    } catch (e) {
      if (context.mounted) {
        _errorPopup(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _dalamProses = false);
      }
    }
  }

  void _suksesPopup() {
    showDialog(
      context: context,
      builder: (context) => _buatSuksesPopup(),
    ).then((_) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _errorPopup(String error) {
    showDialog(
      context: context,
      builder: (context) => _buatErrorPopup(error),
    );
  }

  Widget _buatSuksesPopup() {
    final theme = Theme.of(context);
    
    return AlertDialog(
      backgroundColor: theme.colorScheme.tertiary,
      title: Text(
        'Transaksi Berhasil',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        '${widget.transactionType == 'transfer' ? 'Transfer' : 'Top-Up'} sebesar Rp ${(widget.amount.toInt())} berhasil.',
        style: TextStyle(color: theme.colorScheme.onPrimary),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
          child: const Text('OK'),
          // Lain kali ubah jadi button
        ),
      ],
    );
  }

  Widget _buatErrorPopup(String error) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      backgroundColor: theme.colorScheme.tertiary,
      title: Text(
        'Transaksi Gagal',
        style: TextStyle(
          color: Colors.red.shade300,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Terjadi kesalahan: $error',
        style: TextStyle(color: theme.colorScheme.onPrimary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
          child: const Text('OK'),
          // Lain kali ubah jadi button
        ),
      ],
    );
  }
}
