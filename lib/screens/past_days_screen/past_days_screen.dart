import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/core/utils/extensions/datetime_extensions.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/screens/summary_screen/widgets/summary_items.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

part 'widgets/past_days_items.dart';

class PastDaysScreen extends StatelessWidget {
  PastDaysScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => PastDaysScreen());
  }

  final LocalStorageManager<LocationTrackDay> storageManager =
      getIt<LocalStorageManager<LocationTrackDay>>();

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

          final days = snapshot.data as List<LocationTrackDay>;

          return _PastDaysItems(locationTrackDays: days);
        },
      ),
    );
  }
}
