import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Icon Besar
            CircleAvatar(
              radius: 40,
              backgroundColor: transaction.status == TransactionStatus.success ? Colors.green[100] : Colors.red[100],
              child: Icon(
                transaction.status == TransactionStatus.success ? Icons.check : Icons.close,
                size: 40,
                color: transaction.status == TransactionStatus.success ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(transaction.description, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              currencyFormat.format(transaction.amount),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 30),
            const Divider(),
            _detailRow("Status", transaction.status.name.toUpperCase()),
            _detailRow("Waktu", DateFormat('dd MMM yyyy, HH:mm').format(transaction.date)),
            _detailRow("ID Transaksi", transaction.id),
            _detailRow("Tipe", transaction.type.name),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}