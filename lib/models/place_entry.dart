import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/place.dart';

part 'place_entry.g.dart';

@HiveType(typeId: 1)
class PlaceEntry extends Equatable {
  @HiveField(0)
  final Place place;
  @HiveField(1)
  final DateTime? lastUpdated;
  @HiveField(2)
  final int timeSpent;

  const PlaceEntry({required this.place, this.lastUpdated, this.timeSpent = 0});

  PlaceEntry copyWith({Place? place, DateTime? lastUpdated, int? timeSpent}) {
    return PlaceEntry(
      place: place ?? this.place,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      timeSpent: timeSpent ?? this.timeSpent,
    );
  }

  factory PlaceEntry.fromJson(Map<String, dynamic> json) {
    return PlaceEntry(
      place: Place.fromJson(json['place']),
      lastUpdated:
          json['lastUpdated'] != null
              ? DateTime.parse(json['lastUpdated'])
              : null,
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place.toJson(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'timeSpent': timeSpent,
    };
  }

  @override
  List<Object?> get props => [place];

  @override
  String toString() {
    return 'PlaceEntry(place: $place, lastUpdated: $lastUpdated, timeSpent: $timeSpent)';
  }
}
