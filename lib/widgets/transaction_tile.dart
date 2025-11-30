import 'package:flutter/material.dart';
import 'package:payment_process/models/transaction_model.dart';
import '../screens/transaction_detail_page.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTile({super.key, required this.transaction});

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

  // helper untuk memilih warna status
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

  // helper untuk format mata uang
  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(_getIcon(transaction.type), color: Colors.black87),
      ),

      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        DateFormat('d MMM, HH:mm', 'id_ID').format(transaction.date),
        style: const TextStyle(fontSize: 12),
      ),

      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${transaction.isIncome ? '+' : '-'}${_formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: transaction.isIncome ? Colors.green : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            transaction.status.name.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(transaction.status),
            ),
          ),
        ],
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionDetailPage(transaction: transaction),
          ),
        );
      },
    );
  }
}