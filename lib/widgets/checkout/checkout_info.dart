import 'package:flutter/material.dart';

class CheckoutInfoSection extends StatelessWidget {
  final String paymentType;
  final double amount;
  final String transactionType;

  const CheckoutInfoSection({
    super.key,
    required this.paymentType,
    required this.amount,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      color: theme.colorScheme.tertiary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rincian ${transactionType == 'transfer' ? 'Transfer' : 'Top-Up'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildInfoRows(context),
            const SizedBox(height: 16),
            const _TransferInfo(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInfoRows(BuildContext context) {
    final biayaTotal = _formatCurrency(amount);
    final biayaTotalDanPajak = _formatCurrency(amount + 1000);

    return [
      _buildInfoRow(
        context,
        'Jumlah ${transactionType == 'transfer' ? 'Transfer' : 'Top-Up'}',
        biayaTotal,
      ),
      if (transactionType == 'transfer')
        _buildInfoRow(context, 'Biaya Transfer', _formatCurrency(1000)),
      _buildInfoRow(context, 'Tipe Pembayaran', paymentType),
      const Divider(),
      _buildInfoRow(
        context,
        'Total Bayar',
        transactionType == 'transfer' ? biayaTotalDanPajak : biayaTotal,
        isBold: true,
        textColor: Colors.blue.shade300,
      ),
    ];
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool isBold = false, Color? textColor}) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor ?? theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toInt()}';
  }
}

class _TransferInfo extends StatelessWidget {
  const _TransferInfo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const namaApp = "Scannabit";
    const nomorAkun = "1234-5678-9012";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer ke:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$namaApp - $nomorAkun',
          style: TextStyle(
            color: theme.colorScheme.onPrimary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
