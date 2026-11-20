import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sideproject/models/auth_user.dart';
import 'package:sideproject/models/delivery_location.dart';
import 'package:sideproject/services/current_location_service.dart';
import 'package:sideproject/services/delivery_location_store.dart';

class Location extends StatefulWidget {
  const Location({
    super.key,
    this.user,
    this.onLogout,
    this.locationService,
    this.locationStore,
  });

  final AuthUser? user;
  final Future<void> Function()? onLogout;
  final CurrentLocationService? locationService;
  final DeliveryLocationStore? locationStore;

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late final CurrentLocationService _locationService =
      widget.locationService ?? CurrentLocationService();
  late final DeliveryLocationStore _locationStore =
      widget.locationStore ?? DeliveryLocationStore.instance;
  bool _isLoadingLocation = false;

  void _selectLocation(int selection) {
    if (selection == -1) {
      _useCurrentLocation();
      return;
    }
    _locationStore.update(DeliveryLocationStore.presets[selection]);
  }

  Future<void> _useCurrentLocation() async {
    if (_isLoadingLocation) return;
    setState(() => _isLoadingLocation = true);

    try {
      final location = await _locationService.getCurrentLocation();
      _locationStore.update(location);
    } on LocationException catch (error) {
      if (!mounted) return;
      final canOpenSettings =
          error.message.contains('settings') ||
          error.message.contains('turned off');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          action: canOpenSettings
              ? SnackBarAction(
                  label: error.message.contains('turned off')
                      ? 'Location settings'
                      : 'App settings',
                  onPressed: () {
                    if (error.message.contains('turned off')) {
                      Geolocator.openLocationSettings();
                    } else {
                      Geolocator.openAppSettings();
                    }
                  },
                )
              : null,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get your location: $error')),
      );
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.deepOrange, size: 32),
        Expanded(
          child: ValueListenableBuilder<DeliveryLocation>(
            valueListenable: _locationStore.selected,
            builder: (context, location, child) => PopupMenuButton<int>(
              tooltip: 'Choose delivery location',
              onSelected: _selectLocation,
              itemBuilder: (context) => [
                for (
                  var index = 0;
                  index < DeliveryLocationStore.presets.length;
                  index++
                )
                  PopupMenuItem(
                    value: index,
                    child: Text(
                      '${DeliveryLocationStore.presets[index].city} - '
                      '${DeliveryLocationStore.presets[index].address}',
                    ),
                  ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: -1,
                  enabled: !_isLoadingLocation,
                  child: Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.deepOrange),
                      const SizedBox(width: 10),
                      Text(
                        _isLoadingLocation
                            ? 'Finding your location...'
                            : 'Use current location',
                      ),
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
                            location.city,
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
                                : location.address,
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
            const PopupMenuItem<String>(
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
