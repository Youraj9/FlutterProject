import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/widgets/cart/cart_item.dart';

class CartStore extends ChangeNotifier {
  CartStore();

  static final CartStore instance = CartStore();
  static const _storageKey = 'food_mood_cart';
  SharedPreferences? _preferences;
  bool _isInitialized = false;

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  String? get activeRestaurantId =>
      _items.isEmpty ? null : _items.first.restaurantId;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _preferences = await SharedPreferences.getInstance();
    final encoded = _preferences?.getString(_storageKey);
    if (encoded != null && encoded.isNotEmpty) {
      try {
        final decoded = jsonDecode(encoded);
        if (decoded is List) {
          _items
            ..clear()
            ..addAll(
              decoded.whereType<Map>().map(
                (item) => CartItem.fromJson(Map<String, dynamic>.from(item)),
              ),
            );
        }
      } catch (_) {
        await _preferences?.remove(_storageKey);
      }
    }
    _isInitialized = true;
  }

  Future<void> _persist() async {
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences?.setString(
      _storageKey,
      jsonEncode(_items.map((item) => item.toJson()).toList()),
    );
  }

  bool belongsToRestaurant(String restaurantId) =>
      _items.isEmpty || activeRestaurantId == restaurantId;

  Future<void> replaceCartWith(Restaurant restaurant, FoodItem food) async {
    _items.clear();
    addFoodItem(restaurant, food);
    await _persist();
  }

  bool addFoodItem(Restaurant restaurant, FoodItem food) {
    if (_items.isNotEmpty && _items.first.restaurantId != restaurant.id) {
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
    _persist();
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
    _persist();
  }

  Future<void> updateQuantityAsync(int index, int change) async {
    updateQuantity(index, change);
    await _persist();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
    _persist();
  }
}
