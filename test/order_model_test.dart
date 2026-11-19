import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/models/order.dart';

void main() {
  test(
    'order JSON maps order details and active status from Mongo records',
    () {
      final order = Order.fromJson({
        'id': 'order-1',
        'orderName': 'Database Cafe order',
        'restaurantName': 'Database Cafe',
        'items': [
          {
            'foodItemId': 'food-1',
            'name': 'Database Meal',
            'category': 'Lunch',
            'quantity': 2,
            'unitPrice': 125,
          },
        ],
        'total': 255,
        'status': 'preparing',
        'orderedAt': '2026-11-18T10:05:00.000Z',
        'estimatedDeliveryAt': '2026-11-18T10:35:00.000Z',
      });

      expect(order.orderName, 'Database Cafe order');
      expect(order.items.single.quantity, 2);
      expect(order.total, 255);
      expect(order.isActive, isTrue);
      expect(order.orderedAt, DateTime.utc(2026, 11, 18, 10, 5));
    },
  );

  test('completed and cancelled orders are classified as past orders', () {
    final baseOrder = {
      'id': 'order-1',
      'orderName': 'Database Cafe order',
      'restaurantName': 'Database Cafe',
      'items': <Object>[],
      'total': 0,
      'orderedAt': '2026-11-18T10:05:00.000Z',
    };

    final delivered = Order.fromJson({...baseOrder, 'status': 'delivered'});
    final cancelled = Order.fromJson({...baseOrder, 'status': 'cancelled'});

    expect(delivered.isActive, isFalse);
    expect(cancelled.isActive, isFalse);
  });
}
