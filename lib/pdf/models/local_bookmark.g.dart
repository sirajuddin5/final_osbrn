// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_bookmark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalBookmarkAdapter extends TypeAdapter<LocalBookmark> {
  @override
  final int typeId = 5;

  @override
  LocalBookmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalBookmark(
      id: fields[0] as String?,
      publicationId: fields[1] as String,
      page: (fields[2] as num).toInt(),
      createdAt: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalBookmark obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.publicationId)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalBookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
