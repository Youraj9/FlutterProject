import 'package:flutter/material.dart';

import 'cart_card.dart';
import 'cart_item.dart';
import 'cart_styles.dart';

class CartItemsSection extends StatelessWidget {
  const CartItemsSection({
    required this.items,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  final List<CartItem> items;
  final ValueChanged<int> onDecrease;
  final ValueChanged<int> onIncrease;

  @override
  Widget build(BuildContext context) {
    return CartCard(
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _CartItemRow(
              item: items[index],
              onDecrease: () => onDecrease(index),
              onIncrease: () => onIncrease(index),
            ),
            if (index < items.length - 1)
              const Divider(height: 20, color: CartStyles.divider),
          ],
          const Divider(height: 20, color: CartStyles.divider),
          const Row(
            children: [
              _AddIcon(),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Add more items',
                  style: TextStyle(
                    color: CartStyles.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: CartStyles.accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
  });

  final CartItem item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE8D7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: CartStyles.accent, size: 38),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CartStyles.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: CartStyles.muted, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${item.price}',
                style: const TextStyle(
                  color: CartStyles.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        _QuantityControl(
          quantity: item.quantity,
          onDecrease: onDecrease,
          onIncrease: onIncrease,
        ),
      ],
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F3),
        border: Border.all(color: const Color(0xFFFFD8C2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quantityButton(Icons.remove, onDecrease),
          SizedBox(
            width: 24,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CartStyles.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _quantityButton(Icons.add, onIncrease),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 32,
      height: 36,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        iconSize: 18,
        color: CartStyles.accent,
        icon: Icon(icon),
      ),
    );
  }
}

class _AddIcon extends StatelessWidget {
  const _AddIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: CartStyles.accent,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, size: 16, color: Colors.white),
    );
  }
}
