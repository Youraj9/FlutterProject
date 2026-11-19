class Order {
  const Order({
    required this.id,
    required this.orderName,
    required this.restaurantName,
    required this.items,
    required this.total,
    required this.status,
    required this.orderedAt,
    required this.estimatedDeliveryAt,
  });

  final String id;
  final String orderName;
  final String restaurantName;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime orderedAt;
  final DateTime? estimatedDeliveryAt;

  bool get isActive => const {
    'placed',
    'confirmed',
    'preparing',
    'out_for_delivery',
  }.contains(status);

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    if (rawItems is! List) {
      throw const FormatException('Order items must be a list.');
    }

    final orderedAtValue = json['orderedAt'] ?? json['createdAt'];
    final orderedAt = orderedAtValue is String
        ? DateTime.tryParse(orderedAtValue)
        : null;
    if (orderedAt == null) {
      throw const FormatException('Order is missing a valid order date.');
    }

    final estimatedValue = json['estimatedDeliveryAt'];
    final estimatedDeliveryAt = estimatedValue == null
        ? null
        : estimatedValue is String
        ? DateTime.tryParse(estimatedValue)
        : null;
    if (estimatedValue != null && estimatedDeliveryAt == null) {
      throw const FormatException(
        'Order has an invalid estimated delivery date.',
      );
    }

    return Order(
      id: _requiredString(json, const ['id', '_id']),
      orderName: _requiredString(json, const ['orderName']),
      restaurantName: _requiredString(json, const ['restaurantName']),
      items: rawItems.map((item) {
        if (item is! Map) {
          throw const FormatException('Order contains an invalid item.');
        }
        return OrderItem.fromJson(Map<String, dynamic>.from(item));
      }).toList(),
      total: _number(json['total'], 'total'),
      status: _requiredString(json, const ['status']).toLowerCase(),
      orderedAt: orderedAt,
      estimatedDeliveryAt: estimatedDeliveryAt,
    );
  }

  static String _requiredString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    throw FormatException('Order is missing ${keys.first}.');
  }

  static double _number(dynamic value, String field) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Order field "$field" must be a number.');
  }
}

class OrderItem {
  const OrderItem({
    required this.foodItemId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unitPrice,
  });

  final String foodItemId;
  final String name;
  final String category;
  final int quantity;
  final double unitPrice;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final quantity = json['quantity'];
    if (quantity is! num || quantity < 1 || quantity != quantity.toInt()) {
      throw const FormatException(
        'Order item quantity must be a positive integer.',
      );
    }

    return OrderItem(
      foodItemId: _requiredString(json, const ['foodItemId']),
      name: _requiredString(json, const ['name']),
      category: json['category'] is String ? json['category'] as String : '',
      quantity: quantity.toInt(),
      unitPrice: _number(json['unitPrice'], 'unitPrice'),
    );
  }

  static String _requiredString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    throw FormatException('Order item is missing ${keys.first}.');
  }

  static double _number(dynamic value, String field) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Order item field "$field" must be a number.');
  }
}
