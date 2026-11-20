import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sideproject/models/delivery_location.dart';

class LocationException implements Exception {
  const LocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CurrentLocationService {
  Future<DeliveryLocation> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(
        'Location services are turned off. Enable them and try again.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(
        'Location permission was denied. Allow location access to continue.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission is blocked. Enable it in app settings.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
    final placemarks = await Geocoding().placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final placemark = placemarks.isEmpty ? null : placemarks.first;
    final city = _firstNonEmpty([
      placemark?.locality,
      placemark?.subAdministrativeArea,
      placemark?.administrativeArea,
    ]);
    final address = _firstNonEmpty([
      placemark?.name,
      placemark?.street,
      placemark?.subLocality,
      placemark?.thoroughfare,
    ]);

    return DeliveryLocation(
      city: city ?? 'Current location',
      address:
          address ??
          '${position.latitude.toStringAsFixed(5)}, '
              '${position.longitude.toStringAsFixed(5)}',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }
}
