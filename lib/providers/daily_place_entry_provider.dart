import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/utils/extensions/datetime_extensions.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';
import 'package:location_tracking_app/models/place.dart';
import 'package:location_tracking_app/models/place_entry.dart';
import 'package:location_tracking_app/models/daily_place_entry.dart';
import 'package:location_tracking_app/providers/place_provider.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

/// This provider is used to manage the daily place entries
class DailyPlaceEntryProvider with ChangeNotifier, WidgetsBindingObserver {
  final BackgroundLocationService backgroundLocationService;
  final GeolocatorService geolocatorService;
  final LocalStorageManager<DailyPlaceEntry> storage;
  final PlaceProvider placeProvider;

  DailyPlaceEntryProvider({
    required this.backgroundLocationService,
    required this.geolocatorService,
    required this.storage,
    required this.placeProvider,
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  DailyPlaceEntry? _dailyPlaceEntry;
  DailyPlaceEntry? get dailyPlaceEntry => _dailyPlaceEntry;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  DateTime? _lastUpdate;
  List<PlaceEntry> _activePlaceEntries = [];
  Timer? _tickTimer;

  final double _geofenceRadiusInMeters = 50;
  final double _distanceFilterInMeters = 30;
  final int _timerPeriodInMinutes = 1;

  /// Starts the location tracking service and listens for updates
  Future<void> startTracking() async {
    try {
      if (_isTracking) return;

      await backgroundLocationService.startLocationService(
        distanceFilter: _distanceFilterInMeters,
      );
      backgroundLocationService.getLocationUpdates(_handleLocationUpdate);

      _lastUpdate = DateTime.now();
      _isTracking = true;

      // If the user is not moving, then update the time spent every minute
      _tickTimer = Timer.periodic(Duration(minutes: _timerPeriodInMinutes), (
        _,
      ) {
        _updateTimeSpent(DateTime.now());
      });
      notifyListeners();
    } catch (e) {
      LogHelper.error("Error starting location tracking: $e");
    }
  }

  /// Stops the location tracking service and finalizes any remaining duration
  Future<void> stopTracking() async {
    try {
      if (!_isTracking) return;

      _updateTimeSpent(DateTime.now());
      await _saveDailyPlaceEntry();
      await backgroundLocationService.stopLocationService();

      _tickTimer?.cancel();
      _tickTimer = null;

      _activePlaceEntries = [];
      _lastUpdate = null;
      _isTracking = false;
      notifyListeners();
    } catch (e) {
      LogHelper.error("Error stopping location tracking: $e");
    }
  }

  // Handles the location updates and updates the active locations
  void _handleLocationUpdate(Position position) {
    try {
      _updateTimeSpent(DateTime.now());

      final matched = _getMatchedPlaces(position);
      _activePlaceEntries = matched.isNotEmpty ? matched : [_getTravelPlace()];
      _lastUpdate = DateTime.now();
    } catch (e) {
      LogHelper.error("Error handling location update: $e");
    }
  }

  // Updates the time spent for the active locations
  void _updateTimeSpent(DateTime now) {
    try {
      if (_lastUpdate == null ||
          _activePlaceEntries.isEmpty ||
          _dailyPlaceEntry == null) {
        return;
      }

      DateTime last = _lastUpdate!;

      // Handle the case where the day has changed
      while (!last.isSameDay(now)) {
        final midnight = DateTime(last.year, last.month, last.day + 1);
        final delta = midnight.difference(last).inSeconds;

        _applyDeltaToTracks(
          delta,
          midnight.subtract(const Duration(seconds: 1)),
        );
        _saveDailyPlaceEntry();
        last = midnight;

        _dailyPlaceEntry = DailyPlaceEntry(
          date: DateTime(midnight.year, midnight.month, midnight.day),
          placeEntries: _cloneTracksWithResetTime(midnight),
        );
      }

      final deltaSeconds = now.difference(last).inSeconds;
      if (deltaSeconds <= 0) return;

      _applyDeltaToTracks(deltaSeconds, now);
    } catch (e) {
      LogHelper.error("Error updating time spent: $e");
    }
  }

  // Applies the delta to the active place entries
  void _applyDeltaToTracks(int delta, DateTime updateTime) {
    try {
      final updatedTracks =
          _dailyPlaceEntry!.placeEntries!.map((track) {
            if (_activePlaceEntries.any(
              (active) => active.place.displayName == track.place.displayName,
            )) {
              return PlaceEntry(
                place: track.place,
                timeSpent: track.timeSpent + delta,
                lastUpdated: updateTime,
              );
            } else {
              return track;
            }
          }).toList();

      _dailyPlaceEntry = _dailyPlaceEntry!.copyWith(
        placeEntries: updatedTracks,
      );

      notifyListeners();
    } catch (e) {
      LogHelper.error("Error applying delta to daily place entry: $e");
    }
  }

  // Clones the tracks with the time reset to the given date
  List<PlaceEntry> _cloneTracksWithResetTime(DateTime date) {
    try {
      return _dailyPlaceEntry!.placeEntries!.map((track) {
        return PlaceEntry(place: track.place, timeSpent: 0, lastUpdated: date);
      }).toList();
    } catch (e) {
      LogHelper.error("Error cloning tracks with reset time: $e");
      return [];
    }
  }

  // Saves the daily place entry to the local storage
  Future<void> _saveDailyPlaceEntry() async {
    try {
      if (_dailyPlaceEntry == null || _dailyPlaceEntry!.placeEntries == null) {
        return;
      }

      final key = _formatDateKey(_dailyPlaceEntry!.date!);
      await storage.add(key, _dailyPlaceEntry!);
    } catch (e) {
      LogHelper.error("Error saving daily place entry: $e");
    }
  }

  // Formats the date to a key for the local storage
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get the places that are within the geofence radius
  List<PlaceEntry> _getMatchedPlaces(Position currentPosition) {
    try {
      // Filter out places that have no coordinates
      final geofences =
          _dailyPlaceEntry?.placeEntries
              ?.where(
                (track) =>
                    track.place.latitude != null &&
                    track.place.longitude != null,
              )
              .toList();

      // If no locations are available, return an empty list
      if (geofences == null || geofences.isEmpty) return [];

      // Return the places that are within the geofence radius
      return geofences.where((track) {
        final distance = geolocatorService.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          track.place.latitude!,
          track.place.longitude!,
        );
        return distance <= _geofenceRadiusInMeters;
      }).toList();
    } catch (e) {
      LogHelper.error("Error getting matched places: $e");
      return [];
    }
  }

  // Get the travel place
  PlaceEntry _getTravelPlace() {
    try {
      return _dailyPlaceEntry!.placeEntries!.firstWhere(
        (track) =>
            track.place.latitude == null && track.place.longitude == null,
        orElse: () => const PlaceEntry(place: Place(displayName: 'Travel')),
      );
    } catch (e) {
      LogHelper.error("Error getting travel place: $e");
      return const PlaceEntry(place: Place(displayName: "Travel"));
    }
  }

  /// Loads the daily place entry
  /// If the day does not exist, it will initialize the day with the places
  Future<void> initializeDailyPlaceEntry() async {
    try {
      final today = DateTime.now();
      final key = _formatDateKey(today);

      final saved = await storage.get(key);
      final allPlaces = placeProvider.places;

      if (saved != null) {
        final updatedPlaceEntries = [...saved.placeEntries!];

        for (final place in allPlaces) {
          final exists = updatedPlaceEntries.any(
            (track) => track.place.displayName == place.displayName,
          );
          if (!exists) {
            updatedPlaceEntries.add(
              PlaceEntry(place: place, timeSpent: 0, lastUpdated: today),
            );
          }
        }

        _dailyPlaceEntry = saved.copyWith(placeEntries: updatedPlaceEntries);
      } else {
        _dailyPlaceEntry = DailyPlaceEntry(
          date: today,
          placeEntries:
              allPlaces.map((place) {
                return PlaceEntry(
                  place: place,
                  lastUpdated: today,
                  timeSpent: 0,
                );
              }).toList(),
        );
      }

      notifyListeners();
    } catch (e) {
      LogHelper.error("Error initializing daily place entry: $e");
    }
  }

  /// Refreshes the daily place entry with new places
  void refreshDailyPlaceEntryWithNewPlaces() {
    try {
      if (_dailyPlaceEntry == null) return;

      final allPlaces = placeProvider.places;
      final today = DateTime.now();

      final updatedPlaceEntries = [..._dailyPlaceEntry!.placeEntries!];

      for (final place in allPlaces) {
        final exists = updatedPlaceEntries.any(
          (track) => track.place.displayName == place.displayName,
        );
        if (!exists) {
          updatedPlaceEntries.add(
            PlaceEntry(place: place, timeSpent: 0, lastUpdated: today),
          );
        }
      }

      _dailyPlaceEntry = _dailyPlaceEntry!.copyWith(
        placeEntries: updatedPlaceEntries,
      );
      notifyListeners();
    } catch (e) {
      LogHelper.error("Error refreshing daily place entry with new places: $e");
    }
  }

  /// Adds a new place and refreshes the daily place entry
  Future<void> addPlaceAndRefreshDailyPlaceEntry(String name) async {
    try {
      final position = await geolocatorService.getCurrentPosition();

      final newPlace = Place(
        displayName: name,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await placeProvider.addPlace(newPlace);
      refreshDailyPlaceEntryWithNewPlaces();
    } catch (e) {
      LogHelper.error(
        "Error adding place and refreshing daily place entry: $e",
      );
    }
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      // Save the daily place entry when the app is paused
      if (state == AppLifecycleState.paused) {
        await _saveDailyPlaceEntry();
      }
    } catch (e) {
      LogHelper.error("Error changing app lifecycle state: $e");
    }
  }

  // Dispose the observer
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
