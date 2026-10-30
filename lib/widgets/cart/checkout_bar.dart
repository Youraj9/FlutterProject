import 'package:flutter/material.dart';

import 'cart_styles.dart';

class CheckoutBar extends StatelessWidget {
  const CheckoutBar({required this.payable, super.key});

  final int payable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CartStyles.divider)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₹$payable',
                style: const TextStyle(
                  color: CartStyles.ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'View detailed bill',
                style: TextStyle(
                  color: CartStyles.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: CartStyles.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Proceed to Checkout',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
