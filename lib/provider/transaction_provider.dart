import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../database/transaction_repository.dart';
import 'user_provider.dart';

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  final TransactionRepository _repository;

  TransactionNotifier(this._repository) : super([]);

  Future<void> loadTransactions(int userId) async {
    final transactions = await _repository.getTransactions(userId);
    state = transactions;
  }

  Future<void> addTransaction(TransactionModel transaction, int userId) async {
    state = [transaction, ...state];
  }
}

final transactionProvider = StateNotifierProvider<TransactionNotifier, List<TransactionModel>>(
  (ref) {
    final repository = ref.watch(transactionRepositoryProvider);
    return TransactionNotifier(repository);
  },
);