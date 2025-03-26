import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/place_entry.dart';

part 'daily_place_entry.g.dart';

@HiveType(typeId: 2)
class DailyPlaceEntry extends Equatable {
  @HiveField(0)
  final DateTime? date;
  @HiveField(1)
  final List<PlaceEntry>? placeEntries;

  const DailyPlaceEntry({this.date, this.placeEntries});

  DailyPlaceEntry copyWith({DateTime? date, List<PlaceEntry>? placeEntries}) {
    return DailyPlaceEntry(
      date: date ?? this.date,
      placeEntries: placeEntries ?? this.placeEntries,
    );
  }

  factory DailyPlaceEntry.fromJson(Map<String, dynamic> json) {
    return DailyPlaceEntry(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      placeEntries:
          (json['placeEntries'] as List<dynamic>?)
              ?.map((e) => PlaceEntry.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'locationTracks': placeEntries?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [date, placeEntries];

  @override
  String toString() {
    return 'DailyPlaceEntry(date: $date, placeEntries: $placeEntries)';
  }
}
