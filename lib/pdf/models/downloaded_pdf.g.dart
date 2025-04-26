// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_pdf.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedPdfAdapter extends TypeAdapter<DownloadedPdf> {
  @override
  final int typeId = 1;

  @override
  DownloadedPdf read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedPdf(
      urlId: fields[0] as String,
      title: fields[1] as String,
      localPath: fields[2] as String,
      coverImagePath: fields[3] as String,
      downloadDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedPdf obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.urlId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.localPath)
      ..writeByte(3)
      ..write(obj.coverImagePath)
      ..writeByte(4)
      ..write(obj.downloadDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedPdfAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
