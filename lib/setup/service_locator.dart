import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/daily_summary.dart';
import 'package:location_tracking_app/models/place.dart';
import 'package:location_tracking_app/providers/geolocator_provider.dart';
import 'package:location_tracking_app/providers/place_provider.dart';
import 'package:location_tracking_app/providers/location_tracking_provider.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/hive_local_storage.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';
import 'package:location_tracking_app/utils/consts/hive_boxes.dart';

final getIt = GetIt.instance;

void setupLocator() {
  _registerLocalStorages();
  _registerServices();
  _registerProviders();
}

void _registerLocalStorages() {
  getIt.registerLazySingleton<LocalStorageManager<DailySummary>>(
    () => HiveLocalStorage(Hive.box<DailySummary>(HiveBoxes.dailySummary)),
  );
  getIt.registerLazySingleton<LocalStorageManager<Place>>(
    () => HiveLocalStorage(Hive.box<Place>(HiveBoxes.place)),
  );
}

void _registerServices() {
  getIt.registerLazySingleton<GeolocatorService>(() => GeolocatorService());
  getIt.registerLazySingleton<BackgroundLocationService>(
    () => BackgroundLocationService(),
  );
}

void _registerProviders() {
  getIt.registerLazySingleton<PlaceProvider>(
    () => PlaceProvider(storage: getIt<LocalStorageManager<Place>>()),
  );
  getIt.registerLazySingleton<LocationTrackingProvider>(
    () => LocationTrackingProvider(
      backgroundLocationService: getIt<BackgroundLocationService>(),
      geolocatorService: getIt<GeolocatorService>(),
      storage: getIt<LocalStorageManager<DailySummary>>(),
      placeProvider: getIt<PlaceProvider>(),
    ),
  );
  getIt.registerLazySingleton<GeolocatorProvider>(
    () => GeolocatorProvider(geolocatorService: getIt<GeolocatorService>()),
  );
}
