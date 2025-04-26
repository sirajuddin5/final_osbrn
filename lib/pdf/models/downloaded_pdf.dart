import 'package:hive_ce_flutter/hive_flutter.dart';

part 'downloaded_pdf.g.dart';

@HiveType(typeId: 1)
class DownloadedPdf extends HiveObject {
  @HiveField(0)
  String urlId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String localPath;

  @HiveField(3)
  String coverImagePath;

  @HiveField(4)
  DateTime downloadDate;

  DownloadedPdf({
    required this.urlId,
    required this.title,
    required this.localPath,
    required this.coverImagePath,
    required this.downloadDate,
  });
}
