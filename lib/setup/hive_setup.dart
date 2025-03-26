import 'package:hive_flutter/hive_flutter.dart';
import 'package:location_tracking_app/models/daily_summary.dart';
import 'package:location_tracking_app/models/place.dart';
import 'package:location_tracking_app/models/tracked_location_entry.dart';
import 'package:location_tracking_app/utils/consts/hive_boxes.dart';

Future<void> setupHive() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(TrackedLocationEntryAdapter());
  Hive.registerAdapter(DailySummaryAdapter());

  // Open Boxes
  await Hive.openBox<DailySummary>(HiveBoxes.dailySummary);
  await Hive.openBox<Place>(HiveBoxes.place);
}
