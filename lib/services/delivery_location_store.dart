import 'package:flutter/foundation.dart';

import '../models/delivery_location.dart';

class DeliveryLocationStore {
  DeliveryLocationStore._();

  static final DeliveryLocationStore instance = DeliveryLocationStore._();

  static const presets = [
    DeliveryLocation(city: 'Bengaluru', address: 'Koramangala, 1st Block'),
    DeliveryLocation(city: 'Bengaluru', address: 'Indiranagar'),
    DeliveryLocation(city: 'Mumbai', address: 'Andheri West'),
    DeliveryLocation(city: 'Delhi', address: 'Connaught Place'),
    DeliveryLocation(city: 'Hyderabad', address: 'Madhapur'),
    DeliveryLocation(city: 'Chennai', address: 'T. Nagar'),
  ];

  final ValueNotifier<DeliveryLocation> selected = ValueNotifier(
    presets.first,
  );

  void update(DeliveryLocation location) {
    selected.value = location;
  }
}
