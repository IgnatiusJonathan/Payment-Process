import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/home_screen.dart';
import '../../provider/user_provider.dart';
import '../../models/user.dart';

class CheckoutTimerSection extends ConsumerStatefulWidget {
  final int waktuMundur;

  const CheckoutTimerSection({super.key, required this.waktuMundur});

  @override
  ConsumerState<CheckoutTimerSection> createState() => _CheckoutTimerSectionState();
}

class _CheckoutTimerSectionState extends ConsumerState<CheckoutTimerSection> {
  late int _waktuMundur;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _waktuMundur = widget.waktuMundur;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_waktuMundur > 0) {
        setState(() {
          _waktuMundur--;
        });
      } else {
        _timer.cancel();
        final userState = ref.read(userProvider);
        if (userState != null && mounted) {
          final user = User(
            userId: userState.userID,
            username: userState.username,
            password: '',
            totalSaldo: userState.totalSaldo,
            email: userState.email,
            phone: userState.phone,
          );
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            (route) => false,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
                  _formatTimer(_waktuMundur),
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
