import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/main.dart';
import 'package:sideproject/models/restaurant.dart';

void main() {
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
