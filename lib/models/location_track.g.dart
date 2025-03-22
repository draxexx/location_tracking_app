// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationTrackAdapter extends TypeAdapter<LocationTrack> {
  @override
  final int typeId = 1;

  @override
  LocationTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationTrack(
      location: fields[0] as Location,
      lastUpdated: fields[1] as DateTime?,
      timeSpent: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocationTrack obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.lastUpdated)
      ..writeByte(2)
      ..write(obj.timeSpent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationTrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
