import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/models/restaurant_category.dart';
import 'package:sideproject/screens/Homescreen.dart';
import 'package:sideproject/screens/Searchscreen.dart';
import 'package:sideproject/services/restaurant_service.dart';

void main() {
  testWidgets('home cuisine chips filter MongoDB restaurants', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen1(restaurantService: _TestRestaurantService()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Database Kitchen'), findsOneWidget);
    expect(find.text('South Table'), findsOneWidget);
    expect(find.text('Chinese'), findsOneWidget);

    await tester.tap(find.text('Chinese'));
    await tester.pumpAndSettle();
    expect(find.text('Database Kitchen'), findsOneWidget);
    expect(find.text('South Table'), findsNothing);

    await tester.tap(find.text('South Indian').first);
    await tester.pumpAndSettle();
    expect(find.text('Database Kitchen'), findsNothing);
    expect(find.text('South Table'), findsOneWidget);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Database Kitchen'), findsOneWidget);
    expect(find.text('South Table'), findsOneWidget);
  });

  testWidgets('search filters backend restaurants and uses its back callback', (
    tester,
  ) async {
    var returnedHome = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SearchScreen(
          onBack: () => returnedHome = true,
          restaurantService: _TestRestaurantService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Database Kitchen'), findsOneWidget);
    expect(find.text('South Table'), findsOneWidget);
    expect(find.text('Hard-coded Restaurant'), findsNothing);

    await tester.tap(find.text('South Indian').first);
    await tester.pumpAndSettle();
    expect(find.text('Database Kitchen'), findsNothing);
    expect(find.text('South Table'), findsOneWidget);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Database Kitchen'), findsOneWidget);
    expect(find.text('South Table'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'south indian');
    await tester.pumpAndSettle();
    expect(find.text('Database Kitchen'), findsNothing);
    expect(find.text('South Table'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    expect(returnedHome, isTrue);
  });
}

class _TestRestaurantService extends RestaurantService {
  @override
  Future<List<RestaurantCategory>> fetchCategories() async => const [
    RestaurantCategory(name: 'Indian', restaurantIds: ['restaurant-1']),
    RestaurantCategory(name: 'South Indian', restaurantIds: ['restaurant-2']),
    RestaurantCategory(name: 'Chinese', restaurantIds: ['restaurant-1']),
  ];

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
    Restaurant(
      id: 'restaurant-2',
      name: 'South Table',
      description: 'Regional meals',
      cuisines: ['South Indian'],
      imageUrl: '',
      address: '',
      rating: 4,
      deliveryTimeMinutes: 30,
      deliveryFee: 0,
      minimumOrder: 0,
      isOpen: true,
    ),
  ];
}
