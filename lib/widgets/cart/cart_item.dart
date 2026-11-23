class CartItem {
  const CartItem({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.deliveryFee,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  final String id;
  final String restaurantId;
  final String restaurantName;
  final double deliveryFee;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;

  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'deliveryFee': deliveryFee,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final quantity = json['quantity'];
    return CartItem(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurantId']?.toString() ?? '',
      restaurantName: json['restaurantName']?.toString() ?? '',
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      quantity: quantity is num && quantity >= 1 ? quantity.toInt() : 1,
    );
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      deliveryFee: deliveryFee,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
