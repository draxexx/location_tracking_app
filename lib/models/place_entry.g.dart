// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceEntryAdapter extends TypeAdapter<PlaceEntry> {
  @override
  final int typeId = 1;

  @override
  PlaceEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceEntry(
      place: fields[0] as Place,
      lastUpdated: fields[1] as DateTime?,
      timeSpent: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.place)
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
      other is PlaceEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
