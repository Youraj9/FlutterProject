import 'package:flutter/material.dart';

class OrdercardActive extends StatelessWidget {
  final VoidCallback? onTrackOrder;

  const OrdercardActive({super.key, this.onTrackOrder});

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
                      "Biryani Paradise",
                      style: TextStyle(
                        color: Color(0xFF18243B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Order #ORD1024",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Chicken Biryani, Paneer Tikka",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(color: Color(0xFFE8D9D0)),

          const SizedBox(height: 14),

          // Status and price
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,

                          decoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        const Text(
                          "Preparing your order",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Estimated delivery: 25 minutes",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Text(
                "₹390",
                style: TextStyle(
                  color: Color(0xFF18243B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Track order button
          SizedBox(
            width: double.infinity,
            height: 44,

            child: FilledButton(
              onPressed:
                  onTrackOrder ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order tracking will be implemented"),
                      ),
                    );
                  },

              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFF0E8),
                foregroundColor: Colors.deepOrange,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Track Order",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  SizedBox(width: 6),

                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
