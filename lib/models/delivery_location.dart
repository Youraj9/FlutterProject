class DeliveryLocation {
  const DeliveryLocation({
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
  });

  final String city;
  final String address;
  final double? latitude;
  final double? longitude;

  String get formattedAddress => '$address, $city';
}
