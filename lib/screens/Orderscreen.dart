import 'package:flutter/material.dart';

import 'package:sideproject/widgets/orderscreen/orderheader.dart';
import 'package:sideproject/widgets/orderscreen/ordercard.dart';
import 'package:sideproject/widgets/orderscreen/pastorder.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),

      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Orderheader(),

            // Active and Past Orders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: [
                  _orderTab(label: "Active", index: 0),

                  const SizedBox(width: 10),

                  _orderTab(label: "Past Orders", index: 1),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active order
                    const OrdercardActive(),

                    const SizedBox(height: 24),

                    // Past orders heading
                    const Text(
                      "Past Orders",
                      style: TextStyle(
                        color: Color(0xFF18243B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Past order
                    const Pastorder(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderTab({required String label, required int index}) {
    final bool isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF5A1F) : Colors.transparent,

          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF5A1F)
                : const Color(0xFFE8D9D0),
          ),

          borderRadius: BorderRadius.circular(30),
        ),

        child: Text(
          label,

          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF18243B),

            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
