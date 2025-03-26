import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/utils/consts/enums/location_permission_status.dart';
import 'package:location_tracking_app/utils/helpers/log_helper.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';

class GeolocatorProvider with ChangeNotifier {
  final GeolocatorService geolocatorService;

  LocationPermissionStatus _permissionStatus = LocationPermissionStatus.initial;
  LocationPermissionStatus get permissionStatus => _permissionStatus;

  GeolocatorProvider({required this.geolocatorService});

  Future<void> checkAndRequestPermission() async {
    try {
      final serviceEnabled = await geolocatorService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _permissionStatus = LocationPermissionStatus.serviceDisabled;
        notifyListeners();
        return;
      }

      LocationPermission permission = await geolocatorService.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await geolocatorService.requestPermission();
        if (permission == LocationPermission.denied) {
          _permissionStatus = LocationPermissionStatus.denied;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _permissionStatus = LocationPermissionStatus.deniedForever;
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.whileInUse) {
        final needsAlways = await geolocatorService.needsAlwaysPermission();
        if (needsAlways) {
          _permissionStatus = LocationPermissionStatus.grantedWhileInUse;
          notifyListeners();
          return;
        }
      }

      _permissionStatus = LocationPermissionStatus.grantedAlways;
      notifyListeners();
    } catch (e) {
      LogHelper.error("Error in checkAndRequestPermission: $e");
    }
  }
}
