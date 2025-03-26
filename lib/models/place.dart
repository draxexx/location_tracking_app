import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'place.g.dart';

@HiveType(typeId: 0)
class Place extends Equatable {
  @HiveField(0)
  final String displayName;
  @HiveField(1)
  final double? latitude;
  @HiveField(2)
  final double? longitude;

  const Place({required this.displayName, this.latitude, this.longitude});

  Place copyWith({String? displayName, double? latitude, double? longitude}) {
    return Place(
      displayName: displayName ?? this.displayName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      displayName: json['displayName'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [displayName, latitude, longitude];

  @override
  String toString() {
    return 'Place(displayName: $displayName, latitude: $latitude, longitude: $longitude)';
  }

  bool get isTravel => latitude == null || longitude == null;
}
