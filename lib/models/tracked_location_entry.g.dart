// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracked_location_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackedLocationEntryAdapter extends TypeAdapter<TrackedLocationEntry> {
  @override
  final int typeId = 1;

  @override
  TrackedLocationEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackedLocationEntry(
      place: fields[0] as Place,
      timestamp: fields[1] as DateTime,
      durationInSeconds: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TrackedLocationEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.place)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.durationInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackedLocationEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
