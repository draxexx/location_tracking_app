import 'package:flutter/material.dart';
import 'package:location_tracking_app/widgets/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/widgets/custom_button.dart';
import 'package:location_tracking_app/providers/location_tracking_provider.dart';
import 'package:location_tracking_app/screens/past_days_screen/past_days_screen.dart';
import 'package:location_tracking_app/screens/summary_screen/widgets/tracked_location_entries.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SummaryScreen());
  }

  @override
  Widget build(BuildContext context) {
    final trackedLocationEntries =
        context.watch<LocationTrackingProvider>().trackedLocationEntries;

    final bool hasTrackedLocationEntries = trackedLocationEntries.isNotEmpty;

    return BaseScreenLayout(
      title: "Summary Screen",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                hasTrackedLocationEntries
                    ? TrackedLocationEntries(
                      trackedLocationEntries: trackedLocationEntries,
                    )
                    : const Center(
                      child: Text("No tracked location entries recorded"),
                    ),
          ),
          CustomButton(
            onPressed: () => Navigator.push(context, PastDaysScreen.route()),
            text: "Display Past Days",
          ),
        ],
      ),
    );
  }
}
