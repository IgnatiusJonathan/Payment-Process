import 'package:flutter/material.dart';
import 'package:payment_process/models/transaction_model.dart';
import 'package:payment_process/widgets/transaction_tile.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<TransactionModel> _transactions;

  //code utk menampilkan data transaksi--nanti

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
      // Format tanggal: Minggu, 10 November 2025
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // --- AREA FILTER (Akan kita tambahkan di Langkah 5) ---
          _buildFilterArea(),

          // --- DAFTAR TRANSAKSI ---
          Expanded(
            child: StickyGroupedListView<TransactionModel, DateTime>(
              elements: _transactions, // Data kita

              // 1. Pengelompokan
              groupBy: (transaction) {
                // Kelompokkan berdasarkan Hari, Bulan, dan Tahun (abaikan jam/menit)
                return DateTime(
                  transaction.date.year,
                  transaction.date.month,
                  transaction.date.day,
                );
              },

              // 2. Header Grup (Tanggal)
              groupSeparatorBuilder: (transaction) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[200],
                child: Text(
                  _formatGroupHeader(transaction.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              // 3. Item Transaksi
              itemBuilder: (context, transaction) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TransactionTile(transaction: transaction),
                );
              },

              // 4. Urutan
              order: StickyGroupedListOrder.DESC, // Urutan grup (tanggal terbaru di atas)
              itemScrollController: GroupedItemScrollController(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget placeholder untuk filter
  Widget _buildFilterArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // 1. Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari transaksi...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.zero,
            ),
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
      selected: label == 'Semua',
      onSelected: (selected) {
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue[100],
      labelStyle: TextStyle(
        color: label == 'Semua' ? Colors.blue[800] : Colors.black,
        fontWeight: FontWeight.bold
      ),
    );
  }
}