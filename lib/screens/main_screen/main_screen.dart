import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/screens/summary_screen/summary_screen.dart';
import 'package:location_tracking_app/services/background_location_service.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _startLocationService() async {
    // TODO: remove from here
    final BackgroundLocationService backgroundLocationService =
        BackgroundLocationService();

    await backgroundLocationService.startLocationService(distanceFilter: 30);
    backgroundLocationService.getLocationUpdates();
  }

  void _stopLocationService() async {
    // TODO: remove from here
    final BackgroundLocationService backgroundLocationService =
        BackgroundLocationService();

    await backgroundLocationService.stopLocationService();
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
              onPressed: _startLocationService,
              child: const Text('Clock In'),
            ),
            ElevatedButton(
              onPressed: _stopLocationService,
              child: const Text('Clock Out'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save Location'),
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
