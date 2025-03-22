import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/screens/past_days_screen/past_days_screen.dart';
import 'package:location_tracking_app/screens/summary_screen/widgets/summary_items.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: "Summary Screen",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SummaryItems(
              locationTracks:
                  context
                      .watch<LocationTrackDayProvider>()
                      .locationTrackDay
                      ?.locationTracks ??
                  [],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PastDaysScreen()),
              );
            },
            child: Text('Go to Past Days Screen'),
          ),
        ],
      ),
    );
  }
}
