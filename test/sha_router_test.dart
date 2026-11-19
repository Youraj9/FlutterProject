import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/main.dart';
import 'package:sideproject/models/restaurant.dart';

void main() {
  testWidgets('GoRouter opens the SHA-256 screen and hashes input', (
    tester,
  ) async {
    final router = Swiggy12.router;
    router.go('/sha256');

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('SHA-256'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.tap(find.text('Generate hash'));
    await tester.pump();

    expect(
      find.text(
        'ba7816bf8f01cfea414140de5dae2223'
        'b00361a396177a9cb410ff61f20015ad',
      ),
      findsOneWidget,
    );
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
