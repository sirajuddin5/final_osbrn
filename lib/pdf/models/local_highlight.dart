import 'package:hive_ce_flutter/hive_flutter.dart';

part 'local_highlight.g.dart';

@HiveType(typeId: 2)
class LocalHighlight extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String publicationReaderId;

  @HiveField(2)
  List<PdfTextLineLocal> pdfTextLines;

  LocalHighlight({
    required this.id,
    required this.publicationReaderId,
    required this.pdfTextLines,
  });

  factory LocalHighlight.fromHighlight(dynamic highlight) {
    List<PdfTextLineLocal> lines = [];
    
    // Extract the text lines from the highlight
    if (highlight.pdfTextLines != null) {
      for (var line in highlight.pdfTextLines) {
        lines.add(PdfTextLineLocal(
          x: line['x'],
          y: line['y'],
          width: line['width'],
          height: line['height'],
          text: line['text'],
          pageNumber: line['pageNumber'],
        ));
      }
    }

    return LocalHighlight(
      id: highlight.id,
      publicationReaderId: highlight.publicationReaderId,
      pdfTextLines: lines,
    );
  }

  // Convert to a format compatible with the app's Highlight model
  Map<String, dynamic> toHighlightFormat() {
    final x = pdfTextLines.map((e) => e.x).toList();
    final y = pdfTextLines.map((e) => e.y).toList();
    final width = pdfTextLines.map((e) => e.width).toList();
    final height = pdfTextLines.map((e) => e.height).toList();
    final text = pdfTextLines.map((e) => e.text).toList();
    final page = pdfTextLines.map((e) => e.pageNumber).toList();

    return {
      'id': id,
      'publication_reader_id': publicationReaderId,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'text': text,
      'pageNumber': page
    };
  }
}

@HiveType(typeId: 3)
class PdfTextLineLocal extends HiveObject {
  @HiveField(0)
  double x;

  @HiveField(1)
  double y;

  @HiveField(2)
  double width;

  @HiveField(3)
  double height;

  @HiveField(4)
  String text;

  @HiveField(5)
  int pageNumber;

  PdfTextLineLocal({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.text,
    required this.pageNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'text': text,
      'pageNumber': pageNumber,
    };
  }
}
