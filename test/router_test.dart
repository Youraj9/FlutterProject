import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/main.dart';
import 'package:sideproject/models/restaurant_catalog.dart';
import 'package:sideproject/models/restaurant_category.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/order.dart';
import 'package:sideproject/services/order_service.dart';
import 'package:sideproject/services/restaurant_service.dart';

import 'helpers/test_app_router.dart';

void main() {
  testWidgets('bottom navigation follows distinct GoRouter locations', (
    tester,
  ) async {
    final router = createTestAppRouter(
      restaurantService: _EmptyRestaurantService(),
      orderService: _EmptyOrderService(),
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/home');

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/search');

    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/cart');

    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/orders');
  });

  testWidgets('GoRouter supports a restaurant ID path parameter', (
    tester,
  ) async {
    final router = Swiggy12.router;
    router.go(
      '/restaurants/restaurant-123',
      extra: const Restaurant(
        id: 'restaurant-123',
        name: 'Dynamic Route Cafe',
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
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    expect(
      router.routeInformationProvider.value.uri.path,
      '/restaurants/restaurant-123',
    );
    expect(find.text('Dynamic Route Cafe'), findsOneWidget);
  });
}

class _EmptyRestaurantService extends RestaurantService {
  @override
  Future<RestaurantCatalog> fetchCatalog() async =>
      const RestaurantCatalog(restaurants: [], categories: []);

  @override
  Future<List<Restaurant>> fetchRestaurants() async => [];

  @override
  Future<List<RestaurantCategory>> fetchCategories() async => [];

  @override
  Future<List<FoodItem>> fetchMenu(
    String restaurantId, {
    String? category,
  }) async => [];
}

class _EmptyOrderService extends OrderService {
  @override
  Future<List<Order>> fetchMyOrders() async => [];
}
