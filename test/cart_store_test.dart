import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/services/cart_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('cart items persist and restore from shared preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final store = CartStore();
    await store.initialize();

    store.addFoodItem(_restaurant, _food);
    await store.updateQuantityAsync(0, 1);

    final restored = CartStore();
    await restored.initialize();
    expect(restored.items, hasLength(1));
    expect(restored.items.single.name, 'Database Meal');
    expect(restored.items.single.quantity, 2);
  });

  test('cart rejects a second restaurant until it is replaced', () async {
    SharedPreferences.setMockInitialValues({});
    final store = CartStore();
    await store.initialize();

    expect(store.addFoodItem(_restaurant, _food), isTrue);
    expect(
      store.addFoodItem(
        const Restaurant(
          id: 'restaurant-2',
          name: 'Other Cafe',
          description: '',
          cuisines: ['Cafe'],
          imageUrl: '',
          address: '',
          rating: 4,
          deliveryTimeMinutes: 20,
          deliveryFee: 10,
          minimumOrder: 100,
          isOpen: true,
        ),
        const FoodItem(
          id: 'food-2',
          restaurantId: 'restaurant-2',
          name: 'Other Meal',
          description: '',
          imageUrl: '',
          category: 'Lunch',
          price: 150,
          isVegetarian: true,
          isAvailable: true,
        ),
      ),
      isFalse,
    );
  });
}

const _restaurant = Restaurant(
  id: 'restaurant-1',
  name: 'Database Cafe',
  description: '',
  cuisines: ['Cafe'],
  imageUrl: '',
  address: '',
  rating: 4.5,
  deliveryTimeMinutes: 25,
  deliveryFee: 20,
  minimumOrder: 100,
  isOpen: true,
);

const _food = FoodItem(
  id: 'food-1',
  restaurantId: 'restaurant-1',
  name: 'Database Meal',
  description: 'Fresh',
  imageUrl: '',
  category: 'Lunch',
  price: 125,
  isVegetarian: true,
  isAvailable: true,
);
