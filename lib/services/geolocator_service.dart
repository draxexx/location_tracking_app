import 'dart:io';

import 'package:geolocator/geolocator.dart';

/// A service that provides the current location of the device.
final class GeolocatorService {
  /// This method is used to get the distance between two positions
  /// [latitude1] is the latitude of the first position
  /// [longitude1] is the longitude of the first position
  /// [latitude2] is the latitude of the second position
  /// [longitude2] is the longitude of the second position
  double distanceBetween(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    return Geolocator.distanceBetween(
      latitude1,
      longitude1,
      latitude2,
      longitude2,
    );
  }

  /// Check if the location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check if the app has permission to access the location
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request permission to access the location
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Check if the app has permission to access the location
  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Needs always permission to get the location on background
  Future<bool> needsAlwaysPermission() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse) {
      if (Platform.isAndroid) {
        final newPermission = await Geolocator.requestPermission();
        return newPermission != LocationPermission.always;
      } else if (Platform.isIOS) {
        return true;
      }
    }

    return false;
  }

  /// Get the current position of the device
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}
