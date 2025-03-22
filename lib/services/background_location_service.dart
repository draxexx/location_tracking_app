import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';

/// A service that provides the current location of the device in the background.
final class BackgroundLocationService {
  /// This method is used to get the current location updates
  void getLocationUpdates(Function(Position) onLocationChanged) {
    BackgroundLocation.getLocationUpdates((location) {
      if (location.latitude == null || location.longitude == null) return;

      final position = Position(
        latitude: location.latitude!,
        longitude: location.longitude!,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      onLocationChanged(position);
    });
  }

  /// This method is used to check if the location service is running
  Future<bool> isServiceRunning() async {
    try {
      return await BackgroundLocation.isServiceRunning();
    } catch (e) {
      LogHelper.error("Error checking if service is running: $e");
      rethrow;
    }
  }

  /// This method is used to start the location service
  /// [distanceFilter] is the minimum distance between location updates
  Future<void> startLocationService({double distanceFilter = 0}) async {
    try {
      bool isRunning = await BackgroundLocation.isServiceRunning();

      if (isRunning) return;

      await BackgroundLocation.startLocationService(
        distanceFilter: distanceFilter,
      );

      LogHelper.info("Background location service started");
    } catch (e) {
      LogHelper.error("Error starting background location service: $e");
      rethrow;
    }
  }

  /// This method is used to stop the location service
  Future<void> stopLocationService() async {
    try {
      bool isRunning = await BackgroundLocation.isServiceRunning();

      if (!isRunning) return;

      await BackgroundLocation.stopLocationService();

      LogHelper.info("Background location service stopped");
    } catch (e) {
      LogHelper.error("Error stopping background location service: $e");
      rethrow;
    }
  }
}
