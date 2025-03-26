import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';
import 'package:location_tracking_app/models/place.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

/// This class is used to provide places
class PlaceProvider with ChangeNotifier {
  final LocalStorageManager<Place> storage;

  PlaceProvider({required this.storage});

  List<Place> _places = [];
  List<Place> get places => _places;

  /// This method is used to load places
  Future<void> loadPlaces() async {
    try {
      _places = await storage.getAll();
      notifyListeners();
    } catch (e) {
      _places = [];
      LogHelper.error('Error loading places: $e');
    }
  }

  /// This method is used to add a place
  Future<void> addPlace(Place place) async {
    try {
      await storage.add(place.displayName.toLowerCase(), place);
      _places.add(place);
      notifyListeners();
    } catch (e) {
      LogHelper.error('Error adding place: $e');
    }
  }

  /// This method is used to ensure that the travel place exists
  /// If it does not exist, it will be added
  Future<void> ensureTravelPlaceExists() async {
    try {
      final exists = _places.any(
        (loc) =>
            loc.displayName.toLowerCase() == 'travel' &&
            loc.latitude == null &&
            loc.longitude == null,
      );
      if (!exists) {
        await addPlace(const Place(displayName: 'Travel'));
      }
    } catch (e) {
      LogHelper.error('Error ensuring travel place exists: $e');
    }
  }
}
