import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/core/widgets/custom_button.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/screens/past_days_screen/past_days_screen.dart';
import 'package:location_tracking_app/screens/summary_screen/widgets/summary_items.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SummaryScreen());
  }

  @override
  Widget build(BuildContext context) {
    final placeEntries =
        context.watch<DailyPlaceEntryProvider>().dailyPlaceEntry?.placeEntries;

    final bool hasPlaceEntries =
        placeEntries != null && placeEntries.isNotEmpty;

    return BaseScreenLayout(
      title: "Summary Screen",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                hasPlaceEntries
                    ? SummaryItems(placeEntries: placeEntries)
                    : const Center(child: Text("No place entries recorded")),
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
