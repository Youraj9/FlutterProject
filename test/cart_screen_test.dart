import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/screens/cardscreen.dart';

void main() {
  testWidgets('cart screen lays out its cart details on a phone-sized screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('Chicken Biryani'), findsOneWidget);
    expect(find.text('Paneer Tikka'), findsOneWidget);
    expect(find.text('Apply Coupon'), findsOneWidget);
    expect(find.text('Bill Details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
