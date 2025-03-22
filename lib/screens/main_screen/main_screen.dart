import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/core/utils/permission_helper.dart';
import 'package:location_tracking_app/core/widgets/add_location_dialog.dart';
import 'package:location_tracking_app/core/widgets/custom_button.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/screens/summary_screen/summary_screen.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => MainScreen());
  }

  final LocalStorageManager<LocationTrackDay> storageManager =
      getIt<LocalStorageManager<LocationTrackDay>>();
  final LocalStorageManager<Location> storageManager2 =
      getIt<LocalStorageManager<Location>>();

  final _locationTrackDayProvider = getIt<LocationTrackDayProvider>();

  Future<bool> _hasPermission(BuildContext context) async {
    await _locationTrackDayProvider.checkAndRequestPermission();

    if (context.mounted) {
      return await PermissionHelper.checkAndRequestPermission(
        context: context,
        permissionStatus: _locationTrackDayProvider.permissionStatus,
      );
    }

    return false;
  }

  void _startTracking(BuildContext context) async {
    final hasPermission = await _hasPermission(context);
    if (!hasPermission) return;

    await _locationTrackDayProvider.startTracking();
  }

  void _stopTracking() async {
    await _locationTrackDayProvider.stopTracking();
  }

  // Add a new location to the list of locations
  void _addNewLocation(BuildContext context) async {
    final hasPermission = await _hasPermission(context);
    if (!hasPermission) return;

    if (context.mounted) {
      showAddLocationDialog(
        context: context,
        onSubmit: (name) async {
          await _locationTrackDayProvider.addLocationAndRefreshTrackDay(name);

          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Location added: $name")));
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTracking = context.watch<LocationTrackDayProvider>().isTracking;

    return BaseScreenLayout(
      title: "Main Screen",
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () => _startTracking(context),
              text: "Clock In",
              isDisabled: isTracking,
            ),
            CustomButton(
              onPressed: _stopTracking,
              text: "Clock Out",
              isDisabled: !isTracking,
            ),
            ElevatedButton(
              onPressed: () => storageManager.clear(),
              child: const Text('Clear Tracks'),
            ),
            ElevatedButton(
              onPressed: () => storageManager2.clear(),
              child: const Text('Clear Locations'),
            ),
            CustomButton(
              onPressed: () => _addNewLocation(context),
              text: "Add Location",
              isDisabled: isTracking,
            ),
            CustomButton(
              onPressed: () => Navigator.push(context, SummaryScreen.route()),
              text: "Display Summary",
            ),
          ],
        ),
      ),
    );
  }
}
