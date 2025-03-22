import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/utils/consts/enums/location_permission_status.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';

class GeolocatorProvider extends ChangeNotifier {
  final GeolocatorService geolocatorService;

  LocationPermissionState _permissionState = LocationPermissionState(
    status: LocationPermissionStatus.initial,
  );

  LocationPermissionState get permissionState => _permissionState;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  GeolocatorProvider({required this.geolocatorService});

  Future<void> checkAndRequestPermission() async {
    final serviceEnabled = await geolocatorService.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _permissionState = LocationPermissionState(
        status: LocationPermissionStatus.serviceDisabled,
      );
      notifyListeners();
      return;
    }

    final permission = await geolocatorService.checkPermission();

    if (permission == LocationPermission.denied) {
      final requested = await geolocatorService.requestPermission();
      if (requested == LocationPermission.denied) {
        _permissionState = LocationPermissionState(
          status: LocationPermissionStatus.denied,
        );
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _permissionState = LocationPermissionState(
        status: LocationPermissionStatus.deniedForever,
      );
      notifyListeners();
      return;
    }

    if (permission == LocationPermission.whileInUse) {
      final needsAlways = await geolocatorService.needsAlwaysPermission();
      if (needsAlways) {
        _permissionState = LocationPermissionState(
          status: LocationPermissionStatus.grantedWhileInUse,
        );
        notifyListeners();
        return;
      }
    }

    _permissionState = LocationPermissionState(
      status: LocationPermissionStatus.grantedAlways,
    );
    notifyListeners();
  }

  Future<void> fetchCurrentLocation() async {
    _currentPosition = await geolocatorService.getCurrentPosition();
    notifyListeners();
  }
}
