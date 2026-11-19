import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/order.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/models/restaurant_category.dart';
import 'package:sideproject/screens/Mainpage.dart';
import 'package:sideproject/services/order_service.dart';
import 'package:sideproject/services/restaurant_service.dart';

void main() {
  testWidgets('orders are loaded, filtered by tab, and return home', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainScreen(
          orderService: _TestOrderService([
            _order('active-order', 'preparing', 'Mongo Kitchen'),
            _order('past-order', 'delivered', 'Past Kitchen'),
          ]),
          restaurantService: _TestRestaurantService(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Mongo Kitchen order'), findsOneWidget);
    expect(find.textContaining('Ordered 18 Nov 2026'), findsOneWidget);
    expect(find.text('Past Kitchen order'), findsNothing);

    await tester.tap(find.text('Past Orders'));
    await tester.pumpAndSettle();
    expect(find.text('Past Kitchen order'), findsOneWidget);
    expect(find.text('Mongo Kitchen order'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Top Restaurants Near You'), findsOneWidget);
  });

  testWidgets('placing an order stores it and shows the returned order', (
    tester,
  ) async {
    final orderService = _TestOrderService();
    await tester.pumpWidget(
      MaterialApp(
        home: MainScreen(
          orderService: orderService,
          restaurantService: _TestRestaurantService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add items from restaurant menus'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Database Meal'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();
    expect(find.text('Database Meal'), findsOneWidget);

    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Database Cafe order'), findsOneWidget);
    expect(orderService.orders, hasLength(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Top Restaurants Near You'), findsOneWidget);
  });
}

Order _order(String id, String status, String restaurantName) => Order(
  id: id,
  orderName: '$restaurantName order',
  restaurantName: restaurantName,
  items: const [
    OrderItem(
      foodItemId: 'food-1',
      name: 'Database Meal',
      category: 'Lunch',
      quantity: 1,
      unitPrice: 125,
    ),
  ],
  total: 130,
  status: status,
  orderedAt: DateTime(2026, 11, 18, 10, 5),
  estimatedDeliveryAt: DateTime(2026, 11, 18, 10, 35),
);

class _TestOrderService extends OrderService {
  _TestOrderService([List<Order>? initialOrders])
    : orders = initialOrders ?? [];

  final List<Order> orders;

  @override
  Future<List<Order>> fetchMyOrders() async => List.of(orders);

  @override
  Future<Order> createOrder({
    required String restaurantId,
    required List<OrderItemRequest> items,
  }) async {
    final order = _order(
      'created-order',
      'placed',
      restaurantId == 'restaurant-1' ? 'Database Cafe' : 'Mongo Kitchen',
    );
    orders.insert(0, order);
    return order;
  }
}

class _TestRestaurantService extends RestaurantService {
  @override
  Future<List<RestaurantCategory>> fetchCategories() async => const [
    RestaurantCategory(name: 'Cafe', restaurantIds: ['restaurant-1']),
  ];

  @override
  Future<List<Restaurant>> fetchRestaurants() async => const [
    Restaurant(
      id: 'restaurant-1',
      name: 'Database Cafe',
      description: '',
      cuisines: ['Cafe'],
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
      name: 'Database Meal',
      description: '',
      imageUrl: '',
      category: 'Lunch',
      price: 125,
      isVegetarian: true,
      isAvailable: true,
    ),
  ];
}
