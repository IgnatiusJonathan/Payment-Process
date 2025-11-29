import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../widgets/transaction_tile.dart';
import '../provider/transaction_provider.dart'; // Import provider yang baru dibuat

// UBAH ke ConsumerStatefulWidget
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  // Variable filter UI saja
  String _searchQuery = '';
  String _selectedChip = 'Semua';

  // Helper header tanggal (sama seperti sebelumnya)
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
    // 1. AMBIL DATA REAL DARI PROVIDER
    // ref.watch artinya: "Kalau ada transaksi baru, halaman ini refresh otomatis"
    final allTransactions = ref.watch(transactionProvider);

    // 2. LOGIKA FILTER (Filter data dari provider, bukan mock data)
    final filteredTransactions = allTransactions.where((t) {
      // Filter Text
      final matchesSearch = t.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filter Chip
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
          // Widget Filter (Code sama seperti sebelumnya, dipersingkat di sini)
          _buildFilterArea(),

          // List Transaksi
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
    // ... Copy bagian _buildFilterArea dan _buildFilterChip dari kode sebelumnya ...
    // Pastikan di TextField onChanged: (val) => setState(() => _searchQuery = val);
    // Pastikan di FilterChip onSelected: (val) => setState(() => _selectedChip = label);
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