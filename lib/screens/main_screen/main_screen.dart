import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/screens/summary_screen/summary_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: "Main Screen",
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Clock In')),
            ElevatedButton(onPressed: () {}, child: const Text('Clock Out')),
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
