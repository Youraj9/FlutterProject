import 'package:flutter/material.dart';

class Pastorder extends StatelessWidget {
  final VoidCallback? onReorder;

  const Pastorder({super.key, this.onReorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: const Color(0xFFE8D9D0)),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant information
          Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D8),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.restaurant,
                  color: Colors.deepOrange,
                  size: 28,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Burger Singh",
                      style: TextStyle(
                        color: Color(0xFF18243B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Burger • Fries",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "28 Oct 2026",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Text(
                "₹300",
                style: TextStyle(
                  color: Color(0xFF18243B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(color: Color(0xFFE8D9D0)),

          const SizedBox(height: 12),

          // Delivered status and reorder
          Row(
            children: [
              const Icon(Icons.check, color: Colors.green, size: 18),

              const SizedBox(width: 4),

              const Text(
                "Delivered",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed:
                    onReorder ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Reorder will be implemented"),
                        ),
                      );
                    },

                child: const Text(
                  "Reorder",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
