import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/user_provider.dart';
import '../widgets/navbar.dart';
import '../models/user.dart';
import '../widgets/topup_popup.dart';
import '../widgets/transfer_popup.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Welcome to Scannabit!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "How can we help you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      "Total Saldo",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Rp. ${widget.user.totalSaldo}",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const TransferPopup(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  child: const Text(
                    "Transfer",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 1,
                        )
                      ]
                    )
                  )
                )
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => TopUpPopup(
                        onTopUp: (amount) {
                          ref.read(userProvider.notifier).topUp(amount);
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12)
                      ),
                    ),
                  child: const Text(
                    "Top-Up",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 1,
                        )
                      ]
                    )
                  )
                )
              ),
            ])
          )
        )
      );
    }
  }