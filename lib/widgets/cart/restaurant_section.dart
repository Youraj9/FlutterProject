import 'package:flutter/material.dart';

import 'cart_card.dart';
import 'cart_styles.dart';

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CartCard(
      color: const Color(0xFFFFF3E9),
      borderColor: const Color.fromARGB(255, 34, 34, 34),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4C8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.ramen_dining,
              color: CartStyles.accent,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biryani Paradise',
                  style: TextStyle(
                    color: CartStyles.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Biryani  •  North Indian  •  Chinese',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: CartStyles.muted, fontSize: 13),
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
