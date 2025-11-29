import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopUpPopup extends StatefulWidget {
  final Function(int) onTopUp;

  const TopUpPopup({super.key, required this.onTopUp});

  @override
  State<TopUpPopup> createState() => _TopUpPopupState();
}

class _TopUpPopupState extends State<TopUpPopup> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Top Up Balance",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: "Enter amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                int amount = int.tryParse(_controller.text) ?? 0;

                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid amount")),
                  );
                return;
                }
                widget.onTopUp(amount);
                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }
}
