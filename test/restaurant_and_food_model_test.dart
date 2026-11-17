import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/restaurant.dart';

void main() {
  group('Restaurant.fromJson', () {
    test('parses Mongo-style IDs and numeric fields', () {
      final restaurant = Restaurant.fromJson({
        '_id': 'restaurant-1',
        'name': 'Biryani Paradise',
        'cuisines': ['Biryani', 'North Indian'],
        'rating': 4.5,
        'deliveryTimeMinutes': 30,
        'deliveryFee': '25.50',
        'minimumOrder': 100,
        'isOpen': true,
      });

      expect(restaurant.id, 'restaurant-1');
      expect(restaurant.cuisines, ['Biryani', 'North Indian']);
      expect(restaurant.deliveryFee, 25.5);
    });

    test('rejects records without the required restaurant name', () {
      expect(
        () => Restaurant.fromJson({'id': 'restaurant-1'}),
        throwsFormatException,
      );
    });
  });

  group('FoodItem.fromJson', () {
    test('parses the restaurant reference and price', () {
      final food = FoodItem.fromJson({
        'id': 'food-1',
        'restaurantId': 'restaurant-1',
        'name': 'Paneer Tikka',
        'price': '180.00',
        'isVegetarian': true,
      });

      expect(food.restaurantId, 'restaurant-1');
      expect(food.price, 180);
      expect(food.isVegetarian, isTrue);
      expect(food.isAvailable, isTrue);
    });

    test('rejects invalid prices', () {
      expect(
        () => FoodItem.fromJson({
          'id': 'food-1',
          'restaurantId': 'restaurant-1',
          'name': 'Paneer Tikka',
          'price': 'free',
        }),
        throwsFormatException,
      );
    });
  });
}
