import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/models/location_track.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';

/// This provider is used to manage the location tracking for a day
class LocationTrackDayProvider with ChangeNotifier {
  final BackgroundLocationService backgroundLocationService;
  final GeolocatorService geolocatorService;

  LocationTrackDayProvider({
    required this.backgroundLocationService,
    required this.geolocatorService,
  });

  LocationTrackDay? _trackDay;
  LocationTrackDay? get trackDay => _trackDay;

  bool _isTracking = false;

  /// This method is used to start the location tracking
  Future<void> startTracking() async {
    if (_isTracking) return;

    await backgroundLocationService.startLocationService(distanceFilter: 10);
    backgroundLocationService.getLocationUpdates(handleLocationUpdate);

    _isTracking = true;
  }

  /// This method is used to stop the location tracking
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    await backgroundLocationService.stopLocationService();

    _isTracking = false;
  }

  void handleLocationUpdate(Position position) {
    print("Location update: ${position.latitude}, ${position.longitude}");
  }

  /// This method is used update the location tracking for a day
  /// [trackDay] is the location tracking for a day
  void updateTrack(LocationTrack updatedTrack) {
    if (_trackDay == null || _trackDay!.locationTracks == null) return;

    _trackDay = _trackDay?.copyWith(
      locationTracks:
          _trackDay?.locationTracks!
              .map(
                (element) => element == updatedTrack ? updatedTrack : element,
              )
              .toList(),
    );

    notifyListeners();
  }
}
