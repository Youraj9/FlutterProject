import 'package:flutter/material.dart';

import 'cart_card.dart';
import 'cart_styles.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CartCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0E5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home_rounded, color: CartStyles.accent),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivering to Home',
                  style: TextStyle(
                    color: CartStyles.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Mumbai, Maharashtra',
                  style: TextStyle(color: CartStyles.muted, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const _ChangeLabel(),
        ],
      ),
    );
  }
}

class _ChangeLabel extends StatelessWidget {
  const _ChangeLabel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Change',
          style: TextStyle(
            color: CartStyles.accent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(Icons.chevron_right, color: CartStyles.accent),
      ],
    );
  }
}
