class RestaurantCategory {
  const RestaurantCategory({required this.name, required this.restaurantIds});

  final String name;
  final List<String> restaurantIds;

  factory RestaurantCategory.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final restaurantIds = json['restaurantIds'];
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Restaurant category is missing its name.');
    }
    if (restaurantIds is! List ||
        restaurantIds.any((id) => id is! String || id.trim().isEmpty)) {
      throw const FormatException(
        'Restaurant category contains invalid restaurant IDs.',
      );
    }

    return RestaurantCategory(
      name: name.trim(),
      restaurantIds: restaurantIds.cast<String>(),
    );
  }
}
