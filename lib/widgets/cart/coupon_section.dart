import 'package:flutter/material.dart';

import 'cart_card.dart';
import 'cart_styles.dart';

class CouponSection extends StatelessWidget {
  const CouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CartCard(
      borderColor: const Color(0xFFFFB995),
      child: const Row(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            color: CartStyles.accent,
            size: 28,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Apply Coupon',
              style: TextStyle(
                color: CartStyles.ink,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: CartStyles.accent),
        ],
      ),
    );
  }
}
