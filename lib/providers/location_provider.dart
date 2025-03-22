import 'package:flutter/material.dart';
import 'package:location_tracking_app/models/location.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

class LocationProvider with ChangeNotifier {
  final LocalStorageManager<Location> storage;

  LocationProvider({required this.storage});

  List<Location> _locations = [];
  List<Location> get locations => _locations;

  Future<void> loadLocations() async {
    _locations = await storage.getAll();
    notifyListeners();
  }

  Future<void> addLocation(Location location) async {
    await storage.add(location.displayName.toLowerCase(), location);
    _locations.add(location);
    notifyListeners();
  }

  Future<void> ensureTravelLocationExists() async {
    final exists = _locations.any(
      (loc) =>
          loc.displayName.toLowerCase() == 'travel' &&
          loc.latitude == null &&
          loc.longitude == null,
    );
    if (!exists) {
      await addLocation(Location(displayName: 'Travel'));
    }
  }
}
