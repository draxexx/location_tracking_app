import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/utils/extensions/datetime_extensions.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/models/location_track.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/providers/location_provider.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

/// This provider is used to manage the location tracking for a day
class LocationTrackDayProvider with ChangeNotifier, WidgetsBindingObserver {
  final BackgroundLocationService backgroundLocationService;
  final GeolocatorService geolocatorService;
  final LocalStorageManager<LocationTrackDay> storage;

  LocationTrackDayProvider({
    required this.backgroundLocationService,
    required this.geolocatorService,
    required this.storage,
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  LocationTrackDay? _locationTrackDay;
  LocationTrackDay? get locationTrackDay => _locationTrackDay;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  DateTime? _lastUpdate;
  List<LocationTrack> _activeLocations = [];
  Timer? _tickTimer;

  final double _geofenceRadius = 50;

  /// Starts the location tracking service and listens for updates
  Future<void> startTracking() async {
    if (_isTracking) return;

    await backgroundLocationService.startLocationService(distanceFilter: 30);
    backgroundLocationService.getLocationUpdates(_handleLocationUpdate);

    _lastUpdate = DateTime.now();
    _isTracking = true;

    // If the user is not moving, then update the time spent every minute
    _tickTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTimeSpent(DateTime.now());
    });
    notifyListeners();
  }

  /// Stops the location tracking service and finalizes any remaining duration
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    _updateTimeSpent(DateTime.now());
    await _saveCurrentTrackDay();
    await backgroundLocationService.stopLocationService();

    _tickTimer?.cancel();
    _tickTimer = null;

    _activeLocations = [];
    _lastUpdate = null;
    _isTracking = false;
    notifyListeners();
  }

  // Handles the location updates and updates the active locations
  void _handleLocationUpdate(Position position) {
    _updateTimeSpent(DateTime.now());

    final matched = _getMatchedLocations(position);
    _activeLocations = matched.isNotEmpty ? matched : [_getTravelLocation()];
    _lastUpdate = DateTime.now();
  }

  // Updates the time spent for the active locations
  void _updateTimeSpent(DateTime now) {
    if (_lastUpdate == null ||
        _activeLocations.isEmpty ||
        _locationTrackDay == null) {
      return;
    }

    DateTime last = _lastUpdate!;

    // Handle the case where the day has changed
    while (!last.isSameDay(now)) {
      final midnight = DateTime(last.year, last.month, last.day + 1);
      final delta = midnight.difference(last).inSeconds;

      _applyDeltaToTracks(delta, midnight.subtract(const Duration(seconds: 1)));
      _saveCurrentTrackDay();
      last = midnight;

      _locationTrackDay = LocationTrackDay(
        date: DateTime(midnight.year, midnight.month, midnight.day),
        locationTracks: _cloneTracksWithResetTime(midnight),
      );
    }

    final deltaSeconds = now.difference(last).inSeconds;
    if (deltaSeconds <= 0) return;

    _applyDeltaToTracks(deltaSeconds, now);
  }

  // Applies the delta to the active locations
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

    print("Updated tracks: $_locationTrackDay");
    notifyListeners();
  }

  // Clones the tracks with the time reset to the given date
  List<LocationTrack> _cloneTracksWithResetTime(DateTime date) {
    return _locationTrackDay!.locationTracks!.map((track) {
      return LocationTrack(
        location: track.location,
        timeSpent: 0,
        lastUpdated: date,
      );
    }).toList();
  }

  // Saves the current track day to the local storage
  Future<void> _saveCurrentTrackDay() async {
    if (_locationTrackDay == null ||
        _locationTrackDay!.locationTracks == null) {
      return;
    }

    final key = _formatDateKey(_locationTrackDay!.date!);
    await storage.add(key, _locationTrackDay!);
  }

  // Formats the date to a key for the local storage
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get the locations that are within the geofence radius
  List<LocationTrack> _getMatchedLocations(Position currentPosition) {
    // Filter out locations that have no coordinates
    final geofences =
        _locationTrackDay?.locationTracks
            ?.where(
              (track) =>
                  track.location.latitude != null &&
                  track.location.longitude != null,
            )
            .toList();

    // If no locations are available, return an empty list
    if (geofences == null || geofences.isEmpty) return [];

    // Return the locations that are within the geofence radius
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

  // Get the travel location track
  LocationTrack _getTravelLocation() {
    return _locationTrackDay!.locationTracks!.firstWhere(
      (track) =>
          track.location.latitude == null && track.location.longitude == null,
    );
  }

  /// Loads the location track day for today
  /// If the day does not exist, it will initialize the day with the locations
  Future<void> initializeLocationTrackDay() async {
    final today = DateTime.now();
    final key = _formatDateKey(today);

    final saved = await storage.get(key);
    final allLocations = getIt<LocationProvider>().locations;

    if (saved != null) {
      final updatedTracks = [...saved.locationTracks!];

      for (final loc in allLocations) {
        final exists = updatedTracks.any(
          (track) => track.location.displayName == loc.displayName,
        );
        if (!exists) {
          updatedTracks.add(
            LocationTrack(location: loc, timeSpent: 0, lastUpdated: today),
          );
        }
      }

      _locationTrackDay = saved.copyWith(locationTracks: updatedTracks);
    } else {
      _locationTrackDay = LocationTrackDay(
        date: today,
        locationTracks:
            allLocations.map((loc) {
              return LocationTrack(
                location: loc,
                lastUpdated: today,
                timeSpent: 0,
              );
            }).toList(),
      );
    }

    notifyListeners();
  }

  /// Refreshes the location track day with the latest locations
  void refreshTrackDayWithNewLocations() {
    if (_locationTrackDay == null) return;

    final allLocations = getIt<LocationProvider>().locations;
    final today = DateTime.now();

    final updatedTracks = [..._locationTrackDay!.locationTracks!];

    for (final loc in allLocations) {
      final exists = updatedTracks.any(
        (track) => track.location.displayName == loc.displayName,
      );
      if (!exists) {
        updatedTracks.add(
          LocationTrack(location: loc, timeSpent: 0, lastUpdated: today),
        );
      }
    }

    _locationTrackDay = _locationTrackDay!.copyWith(
      locationTracks: updatedTracks,
    );
    notifyListeners();
  }

  /// Adds a new location and refreshes the location track day
  Future<void> addLocationAndRefreshTrackDay(String name) async {
    final position = await geolocatorService.getCurrentPosition();

    final newLocation = Location(
      displayName: name,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    await getIt<LocationProvider>().addLocation(newLocation);
    refreshTrackDayWithNewLocations();
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Save the current track day when the app is paused
    if (state == AppLifecycleState.paused) {
      await _saveCurrentTrackDay();
    }
  }

  // Dispose the observer
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
