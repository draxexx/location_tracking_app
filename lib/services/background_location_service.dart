import 'package:background_location/background_location.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';

/// This class is used to manage the background location service
final class BackgroundLocationService {
  /// This method is used to get the current location updates
  void getLocationUpdates() {
    BackgroundLocation.getLocationUpdates((location) {
      print(
        "This is your current location: ${location.latitude}, ${location.longitude}",
      );
    });
  }

  /// This method is used to check if the location service is running
  Future<bool> isServiceRunning() async {
    return await BackgroundLocation.isServiceRunning();
  }

  /// This method is used to start the location service
  /// [distanceFilter] is the minimum distance between location updates
  Future<void> startLocationService({double distanceFilter = 0}) async {
    bool isRunning = await BackgroundLocation.isServiceRunning();

    if (isRunning) return;

    await BackgroundLocation.startLocationService(
      distanceFilter: distanceFilter,
    );

    LogHelper.info("Background location service started");
  }

  /// This method is used to stop the location service
  Future<void> stopLocationService() async {
    bool isRunning = await BackgroundLocation.isServiceRunning();

    if (!isRunning) return;

    await BackgroundLocation.stopLocationService();

    LogHelper.info("Background location service stopped");
  }
}
