import 'package:flutter/foundation.dart';

class OrderRefreshStore {
  OrderRefreshStore._();

  static final OrderRefreshStore instance = OrderRefreshStore._();

  final ValueNotifier<int> version = ValueNotifier(0);

  void refresh() {
    version.value++;
  }
}
