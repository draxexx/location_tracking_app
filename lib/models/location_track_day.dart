import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/location_track.dart';

part 'location_track_day.g.dart';

@HiveType(typeId: 2)
class LocationTrackDay extends Equatable {
  @HiveField(0)
  final DateTime? date;
  @HiveField(1)
  final List<LocationTrack>? locationTracks;

  const LocationTrackDay({this.date, this.locationTracks});

  LocationTrackDay copyWith({
    DateTime? date,
    List<LocationTrack>? locationTracks,
  }) {
    return LocationTrackDay(
      date: date ?? this.date,
      locationTracks: locationTracks ?? this.locationTracks,
    );
  }

  factory LocationTrackDay.fromJson(Map<String, dynamic> json) {
    return LocationTrackDay(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      locationTracks:
          (json['locationTracks'] as List<dynamic>?)
              ?.map((e) => LocationTrack.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'locationTracks': locationTracks?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [date, locationTracks];

  @override
  String toString() {
    return 'LocationTrackDay(date: $date, locationTracks: $locationTracks)';
  }
}
