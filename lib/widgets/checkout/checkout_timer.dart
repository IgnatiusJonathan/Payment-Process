import 'package:flutter/material.dart';

class CheckoutTimerSection extends StatelessWidget {
  final int waktuMundur;

  const CheckoutTimerSection({super.key, required this.waktuMundur});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 175, 103, 117).withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: const Color.fromARGB(255, 175, 103, 117)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selesaikan pembayaran dalam:',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimer(waktuMundur),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 175, 103, 117),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
