import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/location.dart';

part 'location_track.g.dart';

@HiveType(typeId: 1)
class LocationTrack extends Equatable {
  @HiveField(0)
  final Location location;
  @HiveField(1)
  final DateTime? entryTime;
  @HiveField(2)
  final DateTime? leftTime;
  @HiveField(3)
  final int timeSpent;

  const LocationTrack({
    required this.location,
    this.entryTime,
    this.leftTime,
    this.timeSpent = 0,
  });

  LocationTrack copyWith({
    Location? location,
    DateTime? entryTime,
    DateTime? leftTime,
    int? timeSpent,
  }) {
    return LocationTrack(
      location: location ?? this.location,
      entryTime: entryTime ?? this.entryTime,
      leftTime: leftTime ?? this.leftTime,
      timeSpent: timeSpent ?? this.timeSpent,
    );
  }

  factory LocationTrack.fromJson(Map<String, dynamic> json) {
    return LocationTrack(
      location: Location.fromJson(json['location']),
      entryTime:
          json['entryTime'] != null ? DateTime.parse(json['entryTime']) : null,
      leftTime:
          json['leftTime'] != null ? DateTime.parse(json['leftTime']) : null,
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'entryTime': entryTime?.toIso8601String(),
      'leftTime': leftTime?.toIso8601String(),
      'timeSpent': timeSpent,
    };
  }

  @override
  List<Object?> get props => [location, entryTime, leftTime, timeSpent];

  @override
  String toString() {
    return 'LocationTrack(location: $location, entryTime: $entryTime, leftTime: $leftTime, timeSpent: $timeSpent)';
  }
}
