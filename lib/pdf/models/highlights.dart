// highlight_model.dart
class Highlight {
  final String id;
  final String publicationReaderId;
  final List<Map<String, dynamic>> pdfTextLines;

  Highlight(
      {required this.id,
      required this.publicationReaderId,
      required this.pdfTextLines});

  // Factory constructor to create a Highlight instance from JSON
  factory Highlight.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> pdfTextLines = [];

    final x = json['x'] ?? [];
    final y = json['y'] ?? [];
    final width = json['width'] ?? [];
    final height = json['height'] ?? [];
    final text = json['text'] ?? [];
    final page = json['pageNumber'] ?? [];

    for (int i = 0; i < x.length; i++) {
      pdfTextLines.add({
        'x': x[i],
        'y': y[i],
        'width': width[i],
        'height': height[i],
        'text': text[i],
        'pageNumber': page[i]
      });
    }

    return Highlight(
        id: json['id'] ?? '',
        publicationReaderId: json['publication_reader_id'] ?? '',
        pdfTextLines: pdfTextLines);
  }

  // Method to convert a Highlight instance to a JSON map (for request body)
  Map<String, dynamic> toJson() {

    final x = pdfTextLines.map((e) => e['x'] as double).toList();
    final y = pdfTextLines.map((e) => e['y'] as double).toList();
    final width = pdfTextLines.map((e) => e['width'] as double).toList();
    final height = pdfTextLines.map((e) => e['height'] as double).toList();
    final text = pdfTextLines.map((e) => e['text'] as String).toList();
    final page = pdfTextLines.map((e) => e['pageNumber'] as int).toList();

    return {
      'publicationId': publicationReaderId,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'text': text,
      'pageNumber': page
    };
  }
}
