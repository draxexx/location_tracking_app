// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_track_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationTrackDayAdapter extends TypeAdapter<LocationTrackDay> {
  @override
  final int typeId = 2;

  @override
  LocationTrackDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationTrackDay(
      date: fields[0] as DateTime?,
      locationTracks: (fields[1] as List?)?.cast<LocationTrack>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocationTrackDay obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.locationTracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationTrackDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
