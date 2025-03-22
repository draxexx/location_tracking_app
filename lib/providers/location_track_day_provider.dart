import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/models/location_track.dart';
import 'package:location_tracking_app/models/location_track_day.dart';
import 'package:location_tracking_app/providers/location_provider.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

/// This provider is used to manage the location tracking for a day
class LocationTrackDayProvider with ChangeNotifier {
  final BackgroundLocationService backgroundLocationService;
  final GeolocatorService geolocatorService;
  final LocalStorageManager<LocationTrackDay> storage;

  LocationTrackDayProvider({
    required this.backgroundLocationService,
    required this.geolocatorService,
    required this.storage,
  });

  LocationTrackDay? _locationTrackDay;
  LocationTrackDay? get locationTrackDay => _locationTrackDay;

  bool _isTracking = false;
  bool _isLocationsInitialized = false;
  DateTime? _lastUpdate;
  List<LocationTrack> _activeLocations = [];
  Timer? _tickTimer;

  final double _geofenceRadius = 50;

  void _initializeLocations(Position position) {
    final today = DateTime.now();
    final locationProvider = getIt<LocationProvider>();
    final allLocations = locationProvider.locations;

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

  /// Starts the location tracking service and listens for updates
  Future<void> startTracking() async {
    if (_isTracking) return;

    await loadTodayTrackDay();

    await backgroundLocationService.startLocationService();
    backgroundLocationService.getLocationUpdates(handleLocationUpdate);

    _lastUpdate = DateTime.now();
    _isTracking = true;

    _tickTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _updateTimeSpent(DateTime.now());
    });
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
  }

  void handleLocationUpdate(Position position) {
    if (!_isLocationsInitialized && _locationTrackDay == null) {
      _initializeLocations(position);
      _isLocationsInitialized = true;
    } else {
      _isLocationsInitialized = true;
    }

    _updateTimeSpent(DateTime.now());

    final matched = _getMatchedLocations(position);
    _activeLocations = matched.isNotEmpty ? matched : [_getTravelLocation()];
    _lastUpdate = DateTime.now();
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

    final deltaSeconds = now.difference(last).inSeconds;
    if (deltaSeconds <= 0) return;

    _applyDeltaToTracks(deltaSeconds, now);
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
    await storage.add(key, _locationTrackDay!);
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

  Future<void> loadTodayTrackDay() async {
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
      _isLocationsInitialized = true;
      notifyListeners();
    }
  }
}
