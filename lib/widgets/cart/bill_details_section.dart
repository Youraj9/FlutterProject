import 'package:flutter/material.dart';

import 'cart_card.dart';
import 'cart_styles.dart';

class BillDetailsSection extends StatelessWidget {
  const BillDetailsSection({
    required this.itemCount,
    required this.itemsTotal,
    required this.deliveryFee,
    required this.platformFee,
    required this.discount,
    super.key,
  });

  final int itemCount;
  final int itemsTotal;
  final int deliveryFee;
  final int platformFee;
  final int discount;

  int get _payable => itemsTotal + deliveryFee + platformFee - discount;

  @override
  Widget build(BuildContext context) {
    return CartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Details',
            style: TextStyle(
              color: CartStyles.ink,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _BillRow('Item Total ($itemCount items)', '₹$itemsTotal'),
          const SizedBox(height: 9),
          _BillRow('Delivery Fee', '₹$deliveryFee'),
          const SizedBox(height: 9),
          _BillRow('Platform Fee', '₹$platformFee'),
          const SizedBox(height: 9),
          _BillRow(
            'Discount',
            '−₹$discount',
            valueColor: const Color(0xFF20A354),
          ),
          const Divider(height: 24, color: CartStyles.divider),
          _BillRow('To Pay', '₹$_payable', emphasize: true),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow(
    this.label,
    this.value, {
    this.valueColor = CartStyles.ink,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: emphasize ? CartStyles.ink : CartStyles.muted,
      fontSize: emphasize ? 18 : 14,
      fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400,
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style.copyWith(color: valueColor)),
      ],
    );
  }
}
// what is copywith means
