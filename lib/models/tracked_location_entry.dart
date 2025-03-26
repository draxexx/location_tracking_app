import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/place.dart';

part 'tracked_location_entry.g.dart';

@HiveType(typeId: 1)
class TrackedLocationEntry extends Equatable {
  @HiveField(0)
  final Place place;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final int durationInSeconds;

  const TrackedLocationEntry({
    required this.place,
    required this.timestamp,
    this.durationInSeconds = 0,
  });

  TrackedLocationEntry copyWith({
    Place? place,
    DateTime? timestamp,
    int? durationInSeconds,
  }) {
    return TrackedLocationEntry(
      place: place ?? this.place,
      timestamp: timestamp ?? this.timestamp,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
    );
  }

  factory TrackedLocationEntry.fromJson(Map<String, dynamic> json) {
    return TrackedLocationEntry(
      place: Place.fromJson(json['place']),
      timestamp: DateTime.parse(json['timestamp']),
      durationInSeconds: json['durationInSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'durationInSeconds': durationInSeconds,
    };
  }

  @override
  List<Object?> get props => [place];

  @override
  String toString() {
    return 'TrackedLocationEntry(place: $place, timestamp: $timestamp, durationInSeconds: $durationInSeconds)';
  }
}
