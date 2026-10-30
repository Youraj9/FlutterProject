import 'package:flutter/material.dart';

import 'cart_styles.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 20, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: CartStyles.ink,
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),
          const Text(
            'Your Cart',
            style: TextStyle(
              color: CartStyles.ink,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
