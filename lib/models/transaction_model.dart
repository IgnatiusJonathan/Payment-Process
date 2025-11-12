enum TransactionType { topup, transfer, payment, bill }
enum TransactionStatus { success, pending, failed }

class TransactionModel {
  final String id;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String description;
  final double amount;
  final bool isIncome;

  TransactionModel({
    required this.id,
    required this.date,
    required this.type,
    required this.status,
    required this.description,
    required this.amount,
    required this.isIncome,
  });
}