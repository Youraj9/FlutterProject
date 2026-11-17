class FoodItem {
  const FoodItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.isVegetarian,
    required this.isAvailable,
  });

  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double price;
  final bool isVegetarian;
  final bool isAvailable;

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: _requiredString(json, const ['id', '_id']),
      restaurantId: _requiredString(json, const [
        'restaurantId',
        'restaurant_id',
      ]),
      name: _requiredString(json, const ['name']),
      description: _optionalString(json['description']),
      imageUrl: _optionalString(json['imageUrl'] ?? json['image']),
      category: _optionalString(json['category']),
      price: _number(json['price']),
      isVegetarian: _boolean(json['isVegetarian'], defaultValue: false),
      isAvailable: _boolean(json['isAvailable'], defaultValue: true),
    );
  }

  static String _requiredString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    throw FormatException('Food item is missing ${keys.first}.');
  }

  static String _optionalString(dynamic value) {
    return value is String ? value.trim() : '';
  }

  static double _number(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw const FormatException('Food item field "price" must be a number.');
  }

  static bool _boolean(dynamic value, {required bool defaultValue}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    throw const FormatException(
      'Food item availability and vegetarian fields must be booleans.',
    );
  }
}
