enum LocationPermissionStatus {
  initial,
  serviceDisabled,
  denied,
  deniedForever,
  grantedWhileInUse,
  grantedAlways,
}

class LocationPermissionState {
  final LocationPermissionStatus status;

  LocationPermissionState({required this.status});
}
