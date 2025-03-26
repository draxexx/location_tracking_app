import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/core/utils/extensions/datetime_extensions.dart';
import 'package:location_tracking_app/models/daily_place_entry.dart';
import 'package:location_tracking_app/screens/summary_screen/widgets/summary_items.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

part 'widgets/past_days_items.dart';

class PastDaysScreen extends StatelessWidget {
  PastDaysScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => PastDaysScreen());
  }

  final LocalStorageManager<DailyPlaceEntry> storageManager =
      getIt<LocalStorageManager<DailyPlaceEntry>>();

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: "Past Days Screen",
      child: FutureBuilder(
        future: storageManager.getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("An error occurred."));
          }

          final days = snapshot.data as List<DailyPlaceEntry>;

          if (days.isEmpty) {
            return const Center(child: Text("No records for past days."));
          }

          return _PastDaysItems(dailyPlaceEntries: days);
        },
      ),
    );
  }
}
