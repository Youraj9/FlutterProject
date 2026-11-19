import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/screens/cardscreen.dart';
import 'package:sideproject/services/restaurant_service.dart';

void main() {
  testWidgets('cart items are selectable from available menu data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: CartScreen(restaurantService: _TestRestaurantService()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('Chicken Biryani'), findsNothing);
    expect(find.text('Apply Coupon'), findsOneWidget);
    expect(find.text('Bill Details'), findsOneWidget);

    await tester.tap(find.text('Add items from restaurant menus'));
    await tester.pumpAndSettle();
    expect(find.text('Mongo Bowl'), findsOneWidget);
    expect(find.text('Unavailable Item'), findsNothing);

    await tester.tap(find.text('Mongo Bowl'));
    await tester.pumpAndSettle();
    expect(find.text('Mongo Bowl'), findsOneWidget);
    expect(find.text('₹175'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}

class _TestRestaurantService extends RestaurantService {
  @override
  Future<List<Restaurant>> fetchRestaurants() async => const [
    Restaurant(
      id: 'restaurant-1',
      name: 'Database Kitchen',
      description: '',
      cuisines: ['Indian'],
      imageUrl: '',
      address: '',
      rating: 4.5,
      deliveryTimeMinutes: 25,
      deliveryFee: 0,
      minimumOrder: 0,
      isOpen: true,
    ),
  ];

  @override
  Future<List<FoodItem>> fetchMenu(
    String restaurantId, {
    String? category,
  }) async => const [
    FoodItem(
      id: 'food-1',
      restaurantId: 'restaurant-1',
      name: 'Mongo Bowl',
      description: 'Freshly prepared',
      imageUrl: '',
      category: 'Lunch',
      price: 175,
      isVegetarian: true,
      isAvailable: true,
    ),
    FoodItem(
      id: 'food-2',
      restaurantId: 'restaurant-1',
      name: 'Unavailable Item',
      description: '',
      imageUrl: '',
      category: 'Dinner',
      price: 200,
      isVegetarian: false,
      isAvailable: false,
    ),
  ];
}
