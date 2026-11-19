import 'package:flutter/material.dart';

import 'cart_card.dart';
import 'cart_item.dart';
import 'cart_styles.dart';

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({required this.items, super.key});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    final restaurantNames = items
        .map((item) => item.restaurantName)
        .toSet()
        .toList();
    final title = restaurantNames.isEmpty
        ? 'Choose from restaurant menus'
        : restaurantNames.length == 1
        ? restaurantNames.first
        : 'Items from ${restaurantNames.length} restaurants';

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CartStyles.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items.isEmpty
                      ? 'Menu items are loaded from the database'
                      : restaurantNames.join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: CartStyles.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
