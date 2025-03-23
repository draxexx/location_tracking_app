import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/core/utils/permission_helper.dart';
import 'package:location_tracking_app/core/widgets/add_location_dialog.dart';
import 'package:location_tracking_app/core/widgets/custom_button.dart';
import 'package:location_tracking_app/providers/geolocator_provider.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/screens/summary_screen/summary_screen.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => MainScreen());
  }

  final _locationTrackDayProvider = getIt<LocationTrackDayProvider>();
  final _geolocatorProvider = getIt<GeolocatorProvider>();
  final geolocatorService = getIt<GeolocatorService>();

  Future<bool> _hasPermission(BuildContext context) async {
    await _geolocatorProvider.checkAndRequestPermission();

    if (context.mounted) {
      return await PermissionHelper.checkAndRequestPermission(
        context: context,
        permissionStatus: _geolocatorProvider.permissionStatus,
        geolocatorService: geolocatorService,
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
            const SizedBox(height: 8),
            CustomButton(
              onPressed: _stopTracking,
              text: "Clock Out",
              isDisabled: !isTracking,
            ),
            const SizedBox(height: 8),
            CustomButton(
              onPressed: () => _addNewLocation(context),
              text: "Save Current Location",
              isDisabled: isTracking,
            ),
            const SizedBox(height: 8),
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
