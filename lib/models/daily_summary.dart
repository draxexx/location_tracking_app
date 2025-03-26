import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:location_tracking_app/models/tracked_location_entry.dart';

part 'daily_summary.g.dart';

@HiveType(typeId: 2)
class DailySummary extends Equatable {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final List<TrackedLocationEntry> trackedLocationEntries;

  const DailySummary({
    required this.date,
    required this.trackedLocationEntries,
  });

  DailySummary copyWith({
    DateTime? date,
    List<TrackedLocationEntry>? trackedLocationEntries,
  }) {
    return DailySummary(
      date: date ?? this.date,
      trackedLocationEntries:
          trackedLocationEntries ?? this.trackedLocationEntries,
    );
  }

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      date: DateTime.parse(json['date']),
      trackedLocationEntries:
          (json['trackedLocationEntries'] as List)
              .map((e) => TrackedLocationEntry.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'trackedLocationEntries':
          trackedLocationEntries.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [date, trackedLocationEntries];

  @override
  String toString() {
    return 'DailySummary(date: $date, trackedLocationEntries: $trackedLocationEntries)';
  }
}
