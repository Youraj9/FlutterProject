import 'package:flutter/material.dart';

class FoodCategories extends StatelessWidget {
  const FoodCategories({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.restaurant, 'color': Color(0xFFFFE5CC)},
    {
      'name': 'South Indian',
      'icon': Icons.rice_bowl,
      'color': Color(0xFFD8F5E5),
    },
    {'name': 'Burgers', 'icon': Icons.lunch_dining, 'color': Color(0xFFFFEBC7)},
    {'name': 'Pizza', 'icon': Icons.local_pizza, 'color': Color(0xFFFFE5CC)},
    {
      'name': 'Beverages',
      'icon': Icons.local_drink,
      'color': Color(0xFFDCEBFF),
    },
    {'name': 'Desserts', 'icon': Icons.cake, 'color': Color(0xFFFFE0EF)},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final category = categories[index];

          return SizedBox(
            width: 76,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 29,
                  backgroundColor: category['color'] as Color,
                  child: Icon(
                    category['icon'] as IconData,
                    // Icondata what it is ??what does it states
                    size: 30,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
