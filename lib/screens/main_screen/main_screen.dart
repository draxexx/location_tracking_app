import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/core/widgets/add_location_dialog.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/providers/location_provider.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/screens/summary_screen/summary_screen.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final LocalStorageManager<LocationTrackDay> storageManager =
      getIt<LocalStorageManager<LocationTrackDay>>();
  final LocalStorageManager<Location> storageManager2 =
      getIt<LocalStorageManager<Location>>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      getIt<LocationTrackDayProvider>().loadTodayTrackDay();

      await getIt<LocationProvider>().loadLocations();
      await getIt<LocationProvider>().ensureTravelLocationExists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: "Main Screen",
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  () =>
                      context.read<LocationTrackDayProvider>().startTracking(),
              child: const Text('Clock In'),
            ),
            ElevatedButton(
              onPressed:
                  () => context.read<LocationTrackDayProvider>().stopTracking(),
              child: const Text('Clock Out'),
            ),
            ElevatedButton(
              onPressed: () => storageManager.clear(),
              child: const Text('Clear Tracks'),
            ),
            ElevatedButton(
              onPressed: () => storageManager2.clear(),
              child: const Text('Clear Locations'),
            ),
            ElevatedButton(
              onPressed:
                  () => showAddLocationDialog(
                    context,
                    getIt<GeolocatorService>(),
                  ),
              child: const Text('Add Location'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SummaryScreen()),
                );
              },
              child: Text('Go to Summary Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
