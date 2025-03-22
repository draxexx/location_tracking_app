import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/models/location_track.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

/// This provider is used to manage the location tracking for a day
class LocationTrackDayProvider with ChangeNotifier {
  final BackgroundLocationService backgroundLocationService;
  final GeolocatorService geolocatorService;
  final LocalStorageManager<LocationTrackDay> storageManager =
      getIt<LocalStorageManager<LocationTrackDay>>();

  LocationTrackDayProvider({
    required this.backgroundLocationService,
    required this.geolocatorService,
  });

  LocationTrackDay? _locationTrackDay;
  LocationTrackDay? get locationTrackDay => _locationTrackDay;

  bool _isTracking = false;
  bool _isLocationsInitialized = false;
  DateTime? _lastUpdate;
  List<LocationTrack> _activeLocations = [];

  final double _geofenceRadius = 50;

  // TODO: remove here
  void _initializeLocations(Position position) {
    _locationTrackDay = LocationTrackDay(
      date: DateTime.now(),
      locationTracks: [
        LocationTrack(
          location: Location(
            latitude: position.latitude,
            longitude: position.longitude,
            displayName: "Home",
          ),
          lastUpdated: DateTime.now(),
          timeSpent: 0,
        ),
        LocationTrack(
          location: Location(
            latitude: position.latitude + (70 / 111320),
            longitude: position.longitude,
            displayName: "Office",
          ),
          lastUpdated: DateTime.now(),
          timeSpent: 0,
        ),
        LocationTrack(
          location: Location(
            latitude: null,
            longitude: null,
            displayName: "Travel",
          ),
          lastUpdated: DateTime.now(),
          timeSpent: 0,
        ),
      ],
    );
  }

  /// Starts the location tracking service and listens for updates
  Future<void> startTracking() async {
    if (_isTracking) return;

    await backgroundLocationService.startLocationService();
    backgroundLocationService.getLocationUpdates(handleLocationUpdate);

    _lastUpdate = DateTime.now();
    _isTracking = true;
  }

  /// Stops the location tracking service and finalizes any remaining duration
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    _updateTimeSpent(DateTime.now());
    await _saveCurrentTrackDay();
    await backgroundLocationService.stopLocationService();

    _activeLocations = [];
    _lastUpdate = null;
    _isTracking = false;
  }

  /// Called when a new location update is received
  void handleLocationUpdate(Position position) {
    if (!_isLocationsInitialized) {
      _initializeLocations(position);
      _isLocationsInitialized = true;
    }

    final now = DateTime.now();
    _updateTimeSpent(now);

    final matched = _getMatchedLocations(position);
    _activeLocations = matched.isNotEmpty ? matched : [_getTravelLocation()];
    _lastUpdate = now;
  }

  void _updateTimeSpent(DateTime now) {
    if (_lastUpdate == null ||
        _activeLocations.isEmpty ||
        _locationTrackDay == null)
      return;

    DateTime last = _lastUpdate!;

    while (!_isSameDay(last, now)) {
      final midnight = DateTime(last.year, last.month, last.day + 1);
      final delta = midnight.difference(last).inSeconds;

      _applyDeltaToTracks(delta, midnight.subtract(Duration(seconds: 1)));
      _saveCurrentTrackDay();
      last = midnight;

      _locationTrackDay = LocationTrackDay(
        date: DateTime(midnight.year, midnight.month, midnight.day),
        locationTracks: _cloneTracksWithResetTime(midnight),
      );
    }

    final delta = now.difference(last).inSeconds;
    _applyDeltaToTracks(delta, now);
  }

  void _applyDeltaToTracks(int delta, DateTime updateTime) {
    final updatedTracks =
        _locationTrackDay!.locationTracks!.map((track) {
          if (_activeLocations.any(
            (active) =>
                active.location.displayName == track.location.displayName,
          )) {
            return LocationTrack(
              location: track.location,
              timeSpent: track.timeSpent + delta,
              lastUpdated: updateTime,
            );
          } else {
            return track;
          }
        }).toList();

    _locationTrackDay = _locationTrackDay!.copyWith(
      locationTracks: updatedTracks,
    );
    notifyListeners();
  }

  List<LocationTrack> _cloneTracksWithResetTime(DateTime date) {
    return _locationTrackDay!.locationTracks!.map((track) {
      return LocationTrack(
        location: track.location,
        timeSpent: 0,
        lastUpdated: date,
      );
    }).toList();
  }

  Future<void> _saveCurrentTrackDay() async {
    if (_locationTrackDay == null || _locationTrackDay!.locationTracks == null)
      return;

    final key = _formatDateKey(_locationTrackDay!.date!);
    await storageManager.add(key, _locationTrackDay!);
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<LocationTrack> _getMatchedLocations(Position currentPosition) {
    final geofences =
        _locationTrackDay?.locationTracks
            ?.where(
              (track) =>
                  track.location.latitude != null &&
                  track.location.longitude != null,
            )
            .toList();

    if (geofences == null || geofences.isEmpty) return [];

    return geofences.where((track) {
      final distance = geolocatorService.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        track.location.latitude!,
        track.location.longitude!,
      );
      return distance <= _geofenceRadius;
    }).toList();
  }

  LocationTrack _getTravelLocation() {
    return _locationTrackDay!.locationTracks!.firstWhere(
      (track) =>
          track.location.latitude == null && track.location.longitude == null,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
