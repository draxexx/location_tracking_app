import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/screens/summary_screen/summary_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<LocationTrackDayProvider>(
        context,
        listen: false,
      ).loadTodayTrackDay();
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
