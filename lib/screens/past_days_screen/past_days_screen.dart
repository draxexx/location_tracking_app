import 'package:flutter/material.dart';
import 'package:location_tracking_app/screens/summary_screen/widgets/tracked_location_entries.dart';
import 'package:location_tracking_app/setup/application_initializer.dart';
import 'package:location_tracking_app/widgets/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/utils/extensions/datetime_extensions.dart';
import 'package:location_tracking_app/models/daily_summary.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

part 'widgets/past_tracked_location_entries.dart';

class PastDaysScreen extends StatelessWidget {
  PastDaysScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => PastDaysScreen());
  }

  final LocalStorageManager<DailySummary> storage =
      getIt<LocalStorageManager<DailySummary>>();

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: "Past Days Screen",
      child: FutureBuilder(
        future: storage.getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("An error occurred."));
          }

          final dailySummaries = snapshot.data as List<DailySummary>;

          if (dailySummaries.isEmpty) {
            return const Center(child: Text("No records for past days."));
          }

          return _PastTrackedLocationEntries(dailySummaries: dailySummaries);
        },
      ),
    );
  }
}
