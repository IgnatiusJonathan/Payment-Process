import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../provider/transaction_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final String hargaTotal = "Rp 100.000";
  final String biayaTransfer = "Rp 1.000";
  final String totalTransfer = "Rp 101.000";
  int waktuMundur = 600;
  final String namaApp = "Masih No Name";
  final String nomorAkun = "(Nanti)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoPembayaran(),

            const SizedBox(height: 24),

            hitungMundur(),

            const SizedBox(height: 24),

            tombolBayar(),
          ],
        ),
      ),
    );
  }

  Widget infoPembayaran() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rincian Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Total Belanja', hargaTotal),
            _buildInfoRow('Biaya Transfer', biayaTransfer),
            const Divider(),
            _buildInfoRow(
              'Total Bayar',
              totalTransfer,
              isBold: true,
              textColor: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Transfer ke:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('$namaApp - $nomorAkun'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget hitungMundur() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selesaikan pembayaran dalam:',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  formatHitung(waktuMundur),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tombolBayar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          panelPin();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'BAYAR SEKARANG',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void panelPin() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            return AlertDialog(
              title: const Text('Masukkan PIN'),
              content: const TextField(
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(hintText: 'Masukkan 6 digit PIN'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('BATAL'),
                ),
                TextButton(
                  onPressed: () {
                    String cleanString = totalTransfer.replaceAll(RegExp(r'[^0-9]'), '');
                    double amount = double.tryParse(cleanString) ?? 0;

                    final newTransaction = TransactionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: DateTime.now(),
                      type: TransactionType.payment, 
                      status: TransactionStatus.success,
                      description: 'Pembayaran $namaApp',
                      amount: amount,
                      isIncome: false,
                    );

                    ref.read(transactionProvider.notifier).addTransaction(newTransaction);

                    Navigator.of(context).pop(); 
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pembayaran Berhasil! Cek History.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('KONFIRMASI'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String formatHitung(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
