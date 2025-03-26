import 'package:flutter/material.dart';
import 'package:location_tracking_app/utils/helpers/log_helper.dart';
import 'package:location_tracking_app/models/place.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

class PlaceProvider with ChangeNotifier {
  final LocalStorageManager<Place> storage;

  PlaceProvider({required this.storage});

  List<Place> _places = [];
  List<Place> get places => _places;

  Future<void> loadPlaces() async {
    try {
      _places = await storage.getAll();
      notifyListeners();
    } catch (e) {
      _places = [];
      LogHelper.error('Error loading places: $e');
    }
  }

  Future<void> addPlace(Place place) async {
    try {
      await storage.add(place.displayName.toLowerCase(), place);
      _places.add(place);
      notifyListeners();
    } catch (e) {
      LogHelper.error('Error adding place: $e');
    }
  }

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
