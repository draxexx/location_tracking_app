import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/providers/location_provider.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';

void showAddLocationDialog(
  BuildContext context,
  GeolocatorService geolocatorService,
) async {
  final TextEditingController controller = TextEditingController();

  final position = await geolocatorService.determinePosition();

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Yeni Lokasyon Ekle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Lokasyon adı (örn: Home)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              final newLocation = Location(
                displayName: name,
                latitude: position.latitude,
                longitude: position.longitude,
              );

              await getIt<LocationProvider>().addLocation(newLocation);
              getIt<LocationTrackDayProvider>()
                  .refreshTrackDayWithNewLocations();

              Navigator.of(ctx).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lokasyon eklendi: $name')),
              );
            },
            child: const Text('Ekle'),
          ),
        ],
      );
    },
  );
}
