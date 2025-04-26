// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_highlight.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalHighlightAdapter extends TypeAdapter<LocalHighlight> {
  @override
  final int typeId = 2;

  @override
  LocalHighlight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalHighlight(
      id: fields[0] as String,
      publicationReaderId: fields[1] as String,
      pdfTextLines: (fields[2] as List).cast<PdfTextLineLocal>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocalHighlight obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.publicationReaderId)
      ..writeByte(2)
      ..write(obj.pdfTextLines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalHighlightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PdfTextLineLocalAdapter extends TypeAdapter<PdfTextLineLocal> {
  @override
  final int typeId = 3;

  @override
  PdfTextLineLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfTextLineLocal(
      x: (fields[0] as num).toDouble(),
      y: (fields[1] as num).toDouble(),
      width: (fields[2] as num).toDouble(),
      height: (fields[3] as num).toDouble(),
      text: fields[4] as String,
      pageNumber: (fields[5] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, PdfTextLineLocal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.width)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.text)
      ..writeByte(5)
      ..write(obj.pageNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfTextLineLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
