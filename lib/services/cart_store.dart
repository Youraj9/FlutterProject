import 'package:flutter/foundation.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/widgets/cart/cart_item.dart';

class CartStore extends ChangeNotifier {
  CartStore();

  static final CartStore instance = CartStore();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool addFoodItem(Restaurant restaurant, FoodItem food) {
    if (_items.isNotEmpty &&
        _items.first.restaurantId != restaurant.id) {
      return false;
    }

    final existingIndex = _items.indexWhere(
      (item) => item.id == food.id && item.restaurantId == restaurant.id,
    );
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(
        CartItem(
          id: food.id,
          restaurantId: restaurant.id,
          restaurantName: restaurant.name,
          deliveryFee: restaurant.deliveryFee,
          name: food.name,
          description: food.description.isEmpty
              ? food.category
              : food.category.isEmpty
              ? food.description
              : '${food.category} • ${food.description}',
          price: food.price,
          imageUrl: food.imageUrl,
        ),
      );
    }
    notifyListeners();
    return true;
  }

  void updateQuantity(int index, int change) {
    final item = _items[index];
    final quantity = item.quantity + change;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = item.copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
