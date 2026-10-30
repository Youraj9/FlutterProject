import 'package:flutter/material.dart';

class CartItem {
  const CartItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    this.quantity = 1,
  });

  final String name;
  final String description;
  final int price;
  final IconData icon;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      name: name,
      description: description,
      price: price,
      icon: icon,
      quantity: quantity ?? this.quantity,
    );
  }

  // here what does the copywith means . why we have defined it
}
