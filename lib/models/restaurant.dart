class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.cuisines,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.deliveryTimeMinutes,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isOpen,
  });

  final String id;
  final String name;
  final String description;
  final List<String> cuisines;
  final String imageUrl;
  final String address;
  final double rating;
  final int deliveryTimeMinutes;
  final double deliveryFee;
  final double minimumOrder;
  final bool isOpen;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: _requiredString(json, const ['id', '_id']),
      name: _requiredString(json, const ['name']),
      description: _optionalString(json['description']),
      cuisines: _stringList(json['cuisines']),
      imageUrl: _optionalString(json['imageUrl'] ?? json['image']),
      address: _optionalString(json['address']),
      rating: _number(json['rating'], 'rating', defaultValue: 0),
      deliveryTimeMinutes: _integer(
        json['deliveryTimeMinutes'] ?? json['deliveryMinutes'],
        'deliveryTimeMinutes',
        defaultValue: 0,
      ),
      deliveryFee: _number(json['deliveryFee'], 'deliveryFee', defaultValue: 0),
      minimumOrder: _number(
        json['minimumOrder'] ?? json['minOrder'],
        'minimumOrder',
        defaultValue: 0,
      ),
      isOpen: _boolean(json['isOpen'], defaultValue: true),
    );
  }

  static String _requiredString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    throw FormatException('Restaurant is missing ${keys.first}.');
  }

  static String _optionalString(dynamic value) {
    return value is String ? value.trim() : '';
  }

  static List<String> _stringList(dynamic value) {
    if (value is String) return [value];
    if (value is List) {
      return value.whereType<String>().map((item) => item.trim()).toList();
    }
    return const [];
  }

  static double _number(
    dynamic value,
    String field, {
    required double defaultValue,
  }) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Restaurant field "$field" must be a number.');
  }

  static int _integer(
    dynamic value,
    String field, {
    required int defaultValue,
  }) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Restaurant field "$field" must be an integer.');
  }

  static bool _boolean(dynamic value, {required bool defaultValue}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    throw const FormatException('Restaurant field "isOpen" must be a boolean.');
  }
}
