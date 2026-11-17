import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/screens/Mainpage.dart';

void main() {
  testWidgets('order back arrow returns to the home tab', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));

    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Preparing your order'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Top Restaurants Near You'), findsOneWidget);
  });
}
