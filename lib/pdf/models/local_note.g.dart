// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalNoteAdapter extends TypeAdapter<LocalNote> {
  @override
  final int typeId = 4;

  @override
  LocalNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalNote(
      id: fields[0] as String?,
      publicationId: fields[1] as String,
      page: (fields[2] as num).toInt(),
      x: (fields[3] as num).toDouble(),
      y: (fields[4] as num).toDouble(),
      color: fields[5] as String,
      text: fields[6] as String,
      createdAt: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalNote obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.publicationId)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.x)
      ..writeByte(4)
      ..write(obj.y)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.text)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
