import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/models/restaurant_catalog.dart';
import 'package:sideproject/models/restaurant_category.dart';
import 'package:sideproject/screens/Mainpage.dart';
import 'package:sideproject/screens/Resdetails.dart';
import 'package:sideproject/services/cart_store.dart';
import 'package:sideproject/services/restaurant_service.dart';

void main() {
  testWidgets('selecting a menu item opens the shared cart', (tester) async {
    final cartStore = CartStore();
    final restaurantService = _TestRestaurantService();
    late final GoRouter router;
    router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => MainScreen(
            cartStore: cartStore,
            restaurantService: restaurantService,
          ),
        ),
        GoRoute(
          path: '/restaurants/:restaurantId',
          builder: (context, state) {
            final navigation = state.extra! as RestaurantDetailsNavigation;
            return RestaurantDetailsScreen(
              restaurant: navigation.restaurant,
              cartStore: navigation.cartStore,
              onOpenCart: navigation.onOpenCart,
              restaurantService: navigation.restaurantService,
            );
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Database Cafe'));
    await tester.tap(find.text('Database Cafe'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Database Meal'));
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('Database Meal'), findsOneWidget);
    expect(cartStore.items.single.name, 'Database Meal');
  });
}

class _TestRestaurantService extends RestaurantService {
  static const _restaurant = Restaurant(
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
  );

  @override
  Future<RestaurantCatalog> fetchCatalog() async => const RestaurantCatalog(
    restaurants: [_restaurant],
    categories: [
      RestaurantCategory(name: 'Cafe', restaurantIds: ['restaurant-1']),
    ],
  );

  @override
  Future<List<Restaurant>> fetchRestaurants() async => const [_restaurant];

  @override
  Future<List<FoodItem>> fetchMenu(
    String restaurantId, {
    String? category,
  }) async => const [
    FoodItem(
      id: 'food-1',
      restaurantId: 'restaurant-1',
      name: 'Database Meal',
      description: 'Freshly prepared',
      imageUrl: '',
      category: 'Lunch',
      price: 125,
      isVegetarian: true,
      isAvailable: true,
    ),
  ];
}
