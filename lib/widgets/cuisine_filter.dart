import 'package:flutter/material.dart';
import 'package:sideproject/models/restaurant_category.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/widgets/cusinecat.dart';

class CuisineFilter extends StatelessWidget {
  const CuisineFilter({
    required this.categories,
    required this.selectedCuisine,
    required this.onSelected,
    super.key,
  });

  final List<RestaurantCategory> categories;
  final String selectedCuisine;
  final ValueChanged<String> onSelected;

  static const _colors = <Color>[
    Color(0xFFFFE5CC),
    Color(0xFFD8F5E5),
    Color(0xFFFFEBC7),
    Color(0xFFDCEBFF),
    Color(0xFFFFE0EF),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cuisine = index == 0 ? 'All' : categories[index - 1].name;
          return Customcusine(
            name: cuisine,
            iconname: _iconForCuisine(cuisine),
            color: _colors[index % _colors.length],
            isSelected: selectedCuisine == cuisine,
            onTap: () => onSelected(cuisine),
          );
        },
      ),
    );
  }

  IconData _iconForCuisine(String cuisine) {
    final normalizedCuisine = cuisine.toLowerCase();
    if (normalizedCuisine == 'all') return Icons.restaurant;
    if (normalizedCuisine.contains('indian')) return Icons.rice_bowl;
    if (normalizedCuisine.contains('chinese')) return Icons.ramen_dining;
    if (normalizedCuisine.contains('burger')) return Icons.lunch_dining;
    if (normalizedCuisine.contains('pizza')) return Icons.local_pizza;
    if (normalizedCuisine.contains('beverage') ||
        normalizedCuisine.contains('drink')) {
      return Icons.local_drink;
    }
    if (normalizedCuisine.contains('dessert') ||
        normalizedCuisine.contains('cake')) {
      return Icons.cake;
    }
    return Icons.restaurant_menu;
  }
}

bool restaurantMatchesCategory(
  Restaurant restaurant,
  String selectedCategory,
  List<RestaurantCategory> categories,
) {
  if (selectedCategory == 'All') return true;
  for (final category in categories) {
    if (category.name.toLowerCase() == selectedCategory.toLowerCase()) {
      return category.restaurantIds.contains(restaurant.id);
    }
  }
  return false;
}
