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
