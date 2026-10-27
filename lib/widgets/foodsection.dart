import 'package:flutter/material.dart';

class Foodsection extends StatelessWidget {
  const Foodsection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 88,
            child: Row(
              children: [
                _category(
                  'All',
                  Icons.soup_kitchen,
                  Colors.deepOrange,
                  const Color(0xFFFFE8C2),
                  selected: true,
                ),
                _category(
                  'South Indian',
                  Icons.rice_bowl,
                  Colors.green,
                  const Color(0xFFE1F6ED),
                ),
                _category(
                  'Burgers',
                  Icons.lunch_dining,
                  Colors.orange,
                  const Color(0xFFFFF0D8),
                ),
                _category(
                  'Pizza',
                  Icons.local_pizza,
                  Colors.deepOrange,
                  const Color(0xFFFFEEDC),
                ),
                _category(
                  'Beverages',
                  Icons.local_drink,
                  Colors.blue,
                  const Color(0xFFE4F1FF),
                ),
                _category(
                  'Desserts',
                  Icons.cake,
                  Colors.pink,
                  const Color(0xFFFFE5F0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _PromotionBanner(),
        ],
      ),
    );
  }

  Widget _category(
    String label,
    IconData icon,
    Color iconColor,
    Color backgroundColor, {
    bool selected = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 21),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            style: TextStyle(
              color: selected ? Colors.deepOrange : const Color(0xFF18243B),
              fontSize: 16,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 24,
            height: 2,
            color: selected ? Colors.deepOrange : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _PromotionBanner extends StatelessWidget {
  const _PromotionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC447), Color(0xFFFF9F1C)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -14,
            top: -18,
            child: Container(
              width: 158,
              height: 158,
              decoration: const BoxDecoration(
                color: Color(0xFFFF8A24),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            right: 12,
            top: 17,
            child: Icon(Icons.rice_bowl, size: 90, color: Color(0xFF7D3217)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5A1F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'FOOD MOOD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Cravings? We’ve\ngot you covered!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Up to 60% OFF on your favourite\nrestaurants',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
