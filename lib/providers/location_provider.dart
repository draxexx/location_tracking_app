import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

/// This class is used to provide locations
class LocationProvider with ChangeNotifier {
  final LocalStorageManager<Location> storage;

  LocationProvider({required this.storage});

  List<Location> _locations = [];
  List<Location> get locations => _locations;

  /// This method is used to load locations
  Future<void> loadLocations() async {
    try {
      _locations = await storage.getAll();
      notifyListeners();
    } catch (e) {
      _locations = [];
      LogHelper.error('Error loading locations: $e');
    }
  }

  /// This method is used to add a location
  Future<void> addLocation(Location location) async {
    try {
      await storage.add(location.displayName.toLowerCase(), location);
      _locations.add(location);
      notifyListeners();
    } catch (e) {
      LogHelper.error('Error adding location: $e');
    }
  }

  /// This method is used to ensure that the travel location exists
  /// If it does not exist, it will be added
  Future<void> ensureTravelLocationExists() async {
    try {
      final exists = _locations.any(
        (loc) =>
            loc.displayName.toLowerCase() == 'travel' &&
            loc.latitude == null &&
            loc.longitude == null,
      );
      if (!exists) {
        await addLocation(const Location(displayName: 'Travel'));
      }
    } catch (e) {
      LogHelper.error('Error ensuring travel location exists: $e');
    }
  }
}
