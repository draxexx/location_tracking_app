import 'package:flutter/material.dart';
import 'package:location_tracking_app/models/location_track.dart';
import 'package:location_tracking_app/models/location_track_day.dart';

/// This provider is used to manage the location tracking for a day
class LocationTrackDayProvider with ChangeNotifier {
  LocationTrackDay? _trackDay;
  LocationTrackDay? get trackDay => _trackDay;

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
