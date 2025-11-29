import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../widgets/transaction_tile.dart';
import '../provider/transaction_provider.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String _searchQuery = '';
  String _selectedChip = 'Semua';

  String _formatGroupHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'Hari Ini';
    } else if (dateToCompare == yesterday) {
      return 'Kemarin';
    } else {
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {

    final allTransactions = ref.watch(transactionProvider);

    final filteredTransactions = allTransactions.where((t) {
      final matchesSearch = t.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesChip = true;
      if (_selectedChip == 'Uang Masuk') matchesChip = t.isIncome;
      if (_selectedChip == 'Uang Keluar') matchesChip = !t.isIncome;
      
      return matchesSearch && matchesChip;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildFilterArea(),

          Expanded(
            child: filteredTransactions.isEmpty 
            ? const Center(child: Text("Belum ada transaksi"))
            : StickyGroupedListView<TransactionModel, DateTime>(
                elements: filteredTransactions,
                groupBy: (transaction) => DateTime(
                  transaction.date.year,
                  transaction.date.month,
                  transaction.date.day,
                ),
                groupSeparatorBuilder: (transaction) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[200],
                  child: Text(
                    _formatGroupHeader(transaction.date),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                itemBuilder: (context, transaction) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TransactionTile(transaction: transaction),
                ),
                order: StickyGroupedListOrder.DESC,
                itemScrollController: GroupedItemScrollController(),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterArea() {
    return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
             TextField(
                decoration: InputDecoration(
                  hintText: 'Cari transaksi...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterChip('Semua'),
                  _buildFilterChip('Uang Masuk'),
                  _buildFilterChip('Uang Keluar'),
                ],
              )
          ],
        ),
      );
  }

  Widget _buildFilterChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedChip == label,
      onSelected: (selected) {
        if (selected) setState(() => _selectedChip = label);
      },
    );
  }
}