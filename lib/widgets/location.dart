import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sideproject/models/auth_user.dart';

class Location extends StatefulWidget {
  const Location({super.key, this.user, this.onLogout});

  final AuthUser? user;
  final Future<void> Function()? onLogout;

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  static const _locations = [
    _DeliveryLocation('Bengaluru', 'Koramangala, 1st Block'),
    _DeliveryLocation('Bengaluru', 'Indiranagar'),
    _DeliveryLocation('Mumbai', 'Andheri West'),
    _DeliveryLocation('Delhi', 'Connaught Place'),
    _DeliveryLocation('Hyderabad', 'Madhapur'),
    _DeliveryLocation('Chennai', 'T. Nagar'),
  ];

  _DeliveryLocation _selectedLocation = _locations.first;
  bool _isLoadingLocation = false;

  Future<void> _selectLocation(int selection) async {
    if (selection == -1) {
      await _useCurrentLocation();
      return;
    }
    setState(() {
      _selectedLocation = _locations[selection];
    });
  }

  Future<void> _useCurrentLocation() async {
    if (_isLoadingLocation) return;
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Please enable location services and try again.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is disabled. Enable it in your device settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final placemark = placemarks.isEmpty ? null : placemarks.first;
      final city = placemark?.locality?.trim().isNotEmpty == true
          ? placemark!.locality!.trim()
          : placemark?.subAdministrativeArea?.trim().isNotEmpty == true
          ? placemark!.subAdministrativeArea!.trim()
          : 'Current location';
      final addressParts =
          [
                placemark?.subLocality,
                placemark?.street,
                placemark?.administrativeArea,
              ]
              .whereType<String>()
              .map((part) => part.trim())
              .where((part) => part.isNotEmpty)
              .toSet();
      final address = addressParts.isEmpty
          ? '${position.latitude.toStringAsFixed(4)}, '
                '${position.longitude.toStringAsFixed(4)}'
          : addressParts.join(', ');

      if (!mounted) return;
      setState(() {
        _selectedLocation = _DeliveryLocation(city, address);
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().startsWith('Exception: ')
                ? error.toString().replaceFirst('Exception: ', '')
                : 'Could not get your current location: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.deepOrange, size: 32),
        Expanded(
          child: PopupMenuButton<int>(
            tooltip: 'Choose delivery location',
            onSelected: _selectLocation,
            itemBuilder: (context) => [
              for (var index = 0; index < _locations.length; index++)
                PopupMenuItem(
                  value: index,
                  child: Text(
                    '${_locations[index].city} - ${_locations[index].address}',
                  ),
                ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: -1,
                enabled: !_isLoadingLocation,
                child: const Row(
                  children: [
                    Icon(Icons.my_location, color: Colors.deepOrange),
                    SizedBox(width: 10),
                    Text('Use current location'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedLocation.city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isLoadingLocation
                              ? 'Finding your location...'
                              : _selectedLocation.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isLoadingLocation
                        ? Icons.more_horiz
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          tooltip: 'Account',
          onSelected: (value) {
            if (value == 'logout') widget.onLogout?.call();
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user?.name.isNotEmpty == true
                        ? widget.user!.name
                        : 'Account',
                    style: const TextStyle(
                      color: Color(0xFF18243B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.user?.email.isNotEmpty == true)
                    Text(
                      widget.user!.email,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Log out'),
                ],
              ),
            ),
          ],
          child: const CircleAvatar(
            radius: 23,
            backgroundColor: Color(0xFFFFF0E8),
            child: Icon(Icons.person, color: Colors.deepOrange, size: 28),
          ),
        ),
      ],
    );
  }
}

class _DeliveryLocation {
  const _DeliveryLocation(this.city, this.address);

  final String city;
  final String address;
}
