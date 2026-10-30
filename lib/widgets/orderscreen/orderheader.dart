import 'package:flutter/material.dart';

class Orderheader extends StatelessWidget {
  final VoidCallback? onBack;

  const Orderheader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed:
                onBack ??
                () {
                  Navigator.maybePop(context);
                },
            icon: const Icon(Icons.arrow_back, size: 20),
          ),

          const SizedBox(width: 4),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "My Orders",
                  style: TextStyle(
                    color: Color(0xFF18243B),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Track your orders and view history",
                  style: TextStyle(color: Color(0xFF858585), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
