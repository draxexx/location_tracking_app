import 'package:flutter/material.dart';
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
    _locations = await storage.getAll();
    notifyListeners();
  }

  /// This method is used to add a location
  Future<void> addLocation(Location location) async {
    await storage.add(location.displayName.toLowerCase(), location);
    _locations.add(location);
    notifyListeners();
  }

  /// This method is used to ensure that the travel location exists
  /// If it does not exist, it will be added
  Future<void> ensureTravelLocationExists() async {
    final exists = _locations.any(
      (loc) =>
          loc.displayName.toLowerCase() == 'travel' &&
          loc.latitude == null &&
          loc.longitude == null,
    );
    if (!exists) {
      await addLocation(const Location(displayName: 'Travel'));
    }
  }
}
