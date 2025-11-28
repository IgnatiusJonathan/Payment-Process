// lib/widgets/transaction_tile.dart
import 'package:flutter/material.dart';
import 'package:payment_process/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTile({Key? key, required this.transaction}) : super(key: key);

  // Helper untuk memilih ikon
  IconData _getIcon(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return Icons.shopping_cart;
      case TransactionType.topup:
        return Icons.account_balance_wallet;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.bill:
        return Icons.receipt;
    }
  }

  // Helper untuk memilih warna status
  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
    }
  }

  // Helper untuk format mata uang
  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // 1. IKON
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(_getIcon(transaction.type), color: Colors.black87),
      ),

      // 2. DESKRIPSI & TANGGAL
      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        // Format tanggal: 12 Nov, 14:30
        DateFormat('d MMM, HH:mm', 'id_ID').format(transaction.date),
        style: const TextStyle(fontSize: 12),
      ),

      // 3. JUMLAH & STATUS
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // Tambah + atau - dan beri warna
            '${transaction.isIncome ? '+' : '-'}${_formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: transaction.isIncome ? Colors.green : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            transaction.status.name.toUpperCase(), // "SUCCESS", "PENDING"
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(transaction.status),
            ),
          ),
        ],
      ),

      // Aksi saat di-tap (kita siapkan untuk Langkah 5)
      onTap: () {
         // Navigator.push(... ke halaman detail);
         print('Tap on ${transaction.id}');
      },
    );
  }
}