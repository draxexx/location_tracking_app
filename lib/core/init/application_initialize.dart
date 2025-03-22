import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracking_app/core/utils/consts/hive_boxes.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/models/location_track.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/providers/location_provider.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/hive_local_storage.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

final getIt = GetIt.instance;

/// This class used to initialize the application dependencies
final class ApplicationInitialize {
  /// This method is used to initialize the application process
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _hiveInitialization();
    _setupLocator();
    _setSystemConfigurations();

    // TODO: remove from here
    GeolocatorService().determinePosition();
  }

  // This method is used to set the system configurations
  void _setSystemConfigurations() {
    // Set Preferred Orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set System UI Overlay Style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // This method is used to initialize the Hive
  Future<void> _hiveInitialization() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(LocationAdapter());
    Hive.registerAdapter(LocationTrackAdapter());
    Hive.registerAdapter(LocationTrackDayAdapter());

    // Open Boxes
    await Hive.openBox<LocationTrackDay>(HiveBoxes.locationTrackDay);
    await Hive.openBox<Location>(HiveBoxes.location);
  }

  // This method is used to setup the locator
  void _setupLocator() {
    // Register Local Storage Managers
    getIt.registerLazySingleton<LocalStorageManager<LocationTrackDay>>(
      () => HiveLocalStorage(
        Hive.box<LocationTrackDay>(HiveBoxes.locationTrackDay),
      ),
    );
    getIt.registerLazySingleton<LocalStorageManager<Location>>(
      () => HiveLocalStorage(Hive.box<Location>(HiveBoxes.location)),
    );

    // Register Services
    getIt.registerLazySingleton<GeolocatorService>(() => GeolocatorService());
    getIt.registerLazySingleton<BackgroundLocationService>(
      () => BackgroundLocationService(),
    );

    // Register Providers
    getIt.registerLazySingleton<LocationProvider>(
      () => LocationProvider(storage: getIt<LocalStorageManager<Location>>()),
    );
    getIt.registerLazySingleton<LocationTrackDayProvider>(
      () => LocationTrackDayProvider(
        backgroundLocationService: getIt<BackgroundLocationService>(),
        geolocatorService: getIt<GeolocatorService>(),
        storage: getIt<LocalStorageManager<LocationTrackDay>>(),
      ),
    );
  }
}
