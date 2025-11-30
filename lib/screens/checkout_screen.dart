import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/checkout/checkout_info.dart';
import '../widgets/checkout/checkout_timer.dart';
import '../widgets/checkout/checkout_payment.dart';
import '../widgets/checkout/pin_dialog.dart';
import '../provider/user_provider.dart';
import '../provider/transaction_provider.dart';
import '../models/transaction_model.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String paymentType;
  final double amount;
  final String transactionType;
  final Function(double)? onTransactionSuccess;

  const CheckoutScreen({
    super.key,
    required this.paymentType,
    required this.amount,
    required this.transactionType,
    this.onTransactionSuccess,
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

        if (widget.transactionType == 'transfer') {
          print('Memproses transfer: ${widget.amount}');
          ref.read(userProvider.notifier).transfer(widget.amount);

          final newTx = TransactionModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            date: DateTime.now(),
            type: TransactionType.transfer,
            status: TransactionStatus.success,
            description: 'Transfer ke ${widget.paymentType}',
            amount: widget.amount,
            isIncome: false,
          );
          ref.read(transactionProvider.notifier).addTransaction(newTx);
        } else if (widget.transactionType == 'topup') {
          print('Memproses topup: ${widget.amount}');
          ref.read(userProvider.notifier).topUp(widget.amount);

          final newTx = TransactionModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            date: DateTime.now(),
            type: TransactionType.topup,
            status: TransactionStatus.success,
            description: 'Top Up Saldo',
            amount: widget.amount,
            isIncome: true,
          );
          ref.read(transactionProvider.notifier).addTransaction(newTx);
        }

        await Future.delayed(const Duration(milliseconds: 300));

        if (context.mounted) {
          _suksesPopup();
        }
      }
    } catch (e) {
      print('Error dalam transaksi: $e');
      if (context.mounted) {
        Navigator.of(context).pop();
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
      barrierDismissible: false,
      builder: (context) {
        return _buatSuksesPopup(context);
      },
    );
  }

  void _errorPopup(String error) {
    showDialog(context: context, builder: (context) => _buatErrorPopup(error));
  }

  Widget _buatSuksesPopup(BuildContext dialogContext) {
    final theme = Theme.of(dialogContext);

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
        '${widget.transactionType == 'transfer' ? 'Top-Up' : 'Transfer'} sebesar Rp ${(widget.amount.toInt())} berhasil.',
        style: TextStyle(color: theme.colorScheme.onPrimary),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();

            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
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
          color: const Color.fromARGB(255, 175, 103, 117),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Terjadi kesalahan: $error',
        style: TextStyle(color: theme.colorScheme.onPrimary),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
