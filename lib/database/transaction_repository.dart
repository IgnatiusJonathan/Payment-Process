import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import '../models/transaction_model.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final db = ref.watch(databaseProvider).value;
  return TransactionRepository(db!);
});

class TransactionRepository {
  final Database db;
  TransactionRepository(this.db);

  Future<void> addTransaction({
    required int userId,
    required String recipient,
    required int amount,
    required String type,
    required String description,
  }) async {
    await db.execute(
      "INSERT INTO HISTORY (userID, Recepient, amount, type, description) VALUES (?, ?, ?, ?, ?)",
      [userId, recipient, amount, type, description],
    );
  }

  Future<List<TransactionModel>> getTransactions(int userId) async {
    final List<Map<String, Object?>> result = await db.getAll(
      "SELECT * FROM HISTORY WHERE userID = ? ORDER BY timestamp DESC",
      [userId],
    );

    return result.map((row) {
      return TransactionModel(
        id: row['HistoryID'].toString(),
        date: DateTime.parse(row['timestamp'] as String),
        type: _parseType(row['type'] as String),
        status: TransactionStatus.success,
        description: row['description'] as String,
        amount: (row['amount'] as int).toDouble(),
        isIncome: (row['type'] as String) == 'topup',
      );
    }).toList();
  }

  TransactionType _parseType(String type) {
    switch (type) {
      case 'topup':
        return TransactionType.topup;
      case 'transfer':
        return TransactionType.transfer;
      case 'payment':
        return TransactionType.payment;
      case 'bill':
        return TransactionType.bill;
      default:
        return TransactionType.payment;
    }
  }
}
