import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/utils/extensions/datetime_extensions.dart';
import 'package:location_tracking_app/utils/helpers/log_helper.dart';
import 'package:location_tracking_app/models/daily_summary.dart';
import 'package:location_tracking_app/models/place.dart';
import 'package:location_tracking_app/models/tracked_location_entry.dart';
import 'package:location_tracking_app/providers/place_provider.dart';
import 'package:location_tracking_app/services/background_location_service.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

class LocationTrackingProvider with ChangeNotifier, WidgetsBindingObserver {
  final BackgroundLocationService backgroundLocationService;
  final GeolocatorService geolocatorService;
  final LocalStorageManager<DailySummary> storage;
  final PlaceProvider placeProvider;

  LocationTrackingProvider({
    required this.backgroundLocationService,
    required this.geolocatorService,
    required this.storage,
    required this.placeProvider,
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  final List<TrackedLocationEntry> _trackedLocationEntries = [];
  List<TrackedLocationEntry> get trackedLocationEntries =>
      _trackedLocationEntries;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  DateTime? _lastTrackedAt;
  List<Place> _activePlaces = [];
  Timer? _durationUpdateTimer;

  final double _geofenceRadiusInMeters = 50;
  final double _distanceFilterInMeters = 30;
  final int _timerPeriodInMinutes = 1;

  Future<void> startTracking() async {
    try {
      if (_isTracking) return;

      await _startBackgroundLocationService();
      _listenToLocationUpdates();
      _startDurationUpdateTimer();

      _lastTrackedAt = DateTime.now();
      _isTracking = true;

      notifyListeners();
    } catch (e) {
      LogHelper.error("Error starting location tracking: $e");
    }
  }

  Future<void> _startBackgroundLocationService() async {
    await backgroundLocationService.startLocationService(
      distanceFilter: _distanceFilterInMeters,
    );
  }

  void _listenToLocationUpdates() {
    backgroundLocationService.getLocationUpdates(_handleLocationUpdate);
  }

  void _startDurationUpdateTimer() {
    _durationUpdateTimer = Timer.periodic(
      Duration(minutes: _timerPeriodInMinutes),
      (_) => _applyElapsedTimeToActivePlaces(DateTime.now()),
    );
  }

  Future<void> stopTracking() async {
    try {
      if (!_isTracking) return;

      final now = DateTime.now();

      _applyElapsedTimeToActivePlaces(now);
      await _saveTrackedLocationEntries(now);
      await _stopBackgroundLocationService();
      _disposeTrackingState();

      notifyListeners();
    } catch (e) {
      LogHelper.error("Error stopping location tracking: $e");
    }
  }

  Future<void> _stopBackgroundLocationService() async {
    await backgroundLocationService.stopLocationService();
  }

  void _disposeTrackingState() {
    _durationUpdateTimer?.cancel();
    _durationUpdateTimer = null;

    _activePlaces = [];
    _lastTrackedAt = null;
    _isTracking = false;
  }

  void _handleLocationUpdate(Position position) {
    try {
      final now = DateTime.now();

      _applyElapsedTimeToActivePlaces(now);
      _updateActivePlaces(position);
      _lastTrackedAt = now;
    } catch (e) {
      LogHelper.error("Error handling location update: $e");
    }
  }

  void _updateActivePlaces(Position position) {
    final matched = _getMatchedPlaces(position);
    _activePlaces = matched.isNotEmpty ? matched : [_getTravel()];
  }

  void _applyElapsedTimeToActivePlaces(DateTime now) {
    try {
      if (_lastTrackedAt == null || _activePlaces.isEmpty) {
        return;
      }

      DateTime last = _lastTrackedAt!;

      // Handle the case where the day has changed
      while (!last.isSameDay(now)) {
        final midnight = DateTime(last.year, last.month, last.day + 1);
        final delta = midnight.difference(last).inSeconds;

        _updateTrackedLocationEntries(
          delta,
          midnight.subtract(const Duration(seconds: 1)),
        );

        _saveTrackedLocationEntries(last);
        _trackedLocationEntries.clear();

        last = midnight;
      }

      final deltaSeconds = now.difference(last).inSeconds;
      if (deltaSeconds > 0) {
        _updateTrackedLocationEntries(deltaSeconds, now);
      }
    } catch (e) {
      LogHelper.error("Error updating time spent: $e");
    }
  }

  void _updateTrackedLocationEntries(int duration, DateTime timestamp) {
    try {
      final day = DateTime(timestamp.year, timestamp.month, timestamp.day);

      for (final place in _activePlaces) {
        final index = _trackedLocationEntries.indexWhere((entry) {
          return day.isSameDay(entry.timestamp) &&
              entry.place.displayName == place.displayName;
        });

        index != -1
            ? _trackedLocationEntries[index] = _trackedLocationEntries[index]
                .copyWith(
                  durationInSeconds:
                      _trackedLocationEntries[index].durationInSeconds +
                      duration,
                )
            : _trackedLocationEntries.add(
              TrackedLocationEntry(
                place: place,
                timestamp: timestamp,
                durationInSeconds: duration,
              ),
            );
      }

      notifyListeners();
    } catch (e) {
      LogHelper.error("Error updating tracked location entries: $e");
    }
  }

  Future<void> _saveTrackedLocationEntries(DateTime date) async {
    try {
      if (_trackedLocationEntries.isEmpty) return;

      final dailySummary = DailySummary(
        date: date,
        trackedLocationEntries: _trackedLocationEntries,
      );

      final key = date.formatDateKey();
      await storage.add(key, dailySummary);
    } catch (e) {
      LogHelper.error("Error saving tracked location entries: $e");
    }
  }

  List<Place> _getMatchedPlaces(Position currentPosition) {
    try {
      final geofences =
          placeProvider.places
              .where(
                (place) => place.latitude != null && place.longitude != null,
              )
              .toList();

      if (geofences.isEmpty) return [];

      return geofences.where((place) {
        final distance = geolocatorService.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          place.latitude!,
          place.longitude!,
        );
        return distance <= _geofenceRadiusInMeters;
      }).toList();
    } catch (e) {
      LogHelper.error("Error getting matched places: $e");
      return [];
    }
  }

  Place _getTravel() {
    try {
      return placeProvider.places.firstWhere(
        (place) => place.latitude == null && place.longitude == null,
        orElse: () => const Place(displayName: 'Travel'),
      );
    } catch (e) {
      LogHelper.error("Error getting travel place: $e");
      return const Place(displayName: "Travel");
    }
  }

  Future<void> initializeTrackedLocationEntries() async {
    try {
      final today = DateTime.now();
      final key = today.formatDateKey();

      final dailySummary = await storage.get(key);

      if (dailySummary != null) {
        _trackedLocationEntries.clear();
        _trackedLocationEntries.addAll(dailySummary.trackedLocationEntries);
        notifyListeners();
      }
    } catch (e) {
      LogHelper.error("Error initializing tracked location entries: $e");
    }
  }

  Future<void> addNewPlace(String name) async {
    try {
      final position = await geolocatorService.getCurrentPosition();

      final newPlace = Place(
        displayName: name,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await placeProvider.addPlace(newPlace);
    } catch (e) {
      LogHelper.error(
        "Error adding place and refreshing daily place entry: $e",
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      switch (state) {
        case AppLifecycleState.paused:
          final now = DateTime.now();
          await _saveTrackedLocationEntries(now);
          break;
        default:
          break;
      }
    } catch (e) {
      LogHelper.error("Error changing app lifecycle state: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
