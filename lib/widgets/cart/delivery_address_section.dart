import 'package:flutter/material.dart';

import '../../models/delivery_location.dart';
import '../../services/current_location_service.dart';
import '../../services/delivery_location_store.dart';
import 'cart_card.dart';
import 'cart_styles.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({
    this.locationStore,
    this.locationService,
    super.key,
  });

  final DeliveryLocationStore? locationStore;
  final CurrentLocationService? locationService;

  @override
  Widget build(BuildContext context) {
    final store = locationStore ?? DeliveryLocationStore.instance;
    return ValueListenableBuilder<DeliveryLocation>(
      valueListenable: store.selected,
      builder: (context, location, child) => CartCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0E5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_rounded, color: CartStyles.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivering to ${location.city}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CartStyles.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CartStyles.muted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => _showLocationPicker(
                context,
                store,
                locationService ?? CurrentLocationService(),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change',
                    style: TextStyle(
                      color: CartStyles.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: CartStyles.accent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLocationPicker(
    BuildContext context,
    DeliveryLocationStore store,
    CurrentLocationService service,
  ) async {
    final useCurrentLocation = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Choose delivery location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            for (final location in DeliveryLocationStore.presets)
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(location.address),
                subtitle: Text(location.city),
                onTap: () {
                  store.update(location);
                  Navigator.pop(sheetContext, false);
                },
              ),
            ListTile(
              leading: const Icon(Icons.my_location, color: CartStyles.accent),
              title: const Text('Use current location'),
              onTap: () => Navigator.pop(sheetContext, true),
            ),
          ],
        ),
      ),
    );

    if (useCurrentLocation != true || !context.mounted) return;
    try {
      store.update(await service.getCurrentLocation());
    } on LocationException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get your location: $error')),
      );
    }
  }
}
