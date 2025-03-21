import 'dart:io';

import 'package:geolocator/geolocator.dart';

/// A service that provides the current location of the device.
final class GeolocatorService {
  /// This method is used to get the distance between two positions
  /// [position1] is the first position
  /// [position2] is the second position
  double distanceBetween(Position position1, Position position2) {
    return Geolocator.distanceBetween(
      position1.latitude,
      position1.longitude,
      position2.latitude,
      position2.longitude,
    );
  }

  /// This method is used to get the current location
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    if (permission == LocationPermission.whileInUse) {
      print("while in use");
      if (Platform.isAndroid) {
        permission = await Geolocator.requestPermission();
      } else if (Platform.isIOS) {
        await Geolocator.openAppSettings();
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
