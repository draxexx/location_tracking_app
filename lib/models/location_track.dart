import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/location.dart';

part 'location_track.g.dart';

@HiveType(typeId: 1)
class LocationTrack extends Equatable {
  @HiveField(0)
  final Location location;
  @HiveField(1)
  final DateTime? lastUpdated;
  @HiveField(2)
  final int timeSpent;

  const LocationTrack({
    required this.location,
    this.lastUpdated,
    this.timeSpent = 0,
  });

  LocationTrack copyWith({
    Location? location,
    DateTime? lastUpdated,
    int? timeSpent,
  }) {
    return LocationTrack(
      location: location ?? this.location,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      timeSpent: timeSpent ?? this.timeSpent,
    );
  }

  factory LocationTrack.fromJson(Map<String, dynamic> json) {
    return LocationTrack(
      location: Location.fromJson(json['location']),
      lastUpdated:
          json['lastUpdated'] != null
              ? DateTime.parse(json['lastUpdated'])
              : null,
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'timeSpent': timeSpent,
    };
  }

  @override
  List<Object?> get props => [location];

  @override
  String toString() {
    return 'LocationTrack(location: $location, lastUpdated: $lastUpdated, timeSpent: $timeSpent)';
  }
}
