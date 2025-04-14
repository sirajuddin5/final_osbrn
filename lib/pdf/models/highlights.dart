// highlight_model.dart
class Highlight {
  final String id;
  final String publicationId;
  final List<Map<String,dynamic>> pdfTextLines;

  Highlight({
    required this.id,
    required this.publicationId,
    required this.pdfTextLines

  });

  // Factory constructor to create a Highlight instance from JSON
  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'] ?? '',
      publicationId: json['publication_id'] ?? '',
    pdfTextLines: [],

    );
  }

  // Method to convert a Highlight instance to a JSON map (for request body)
  Map<String, dynamic> toJson() {
    return {
      'publicationId': publicationId,


    };
  }
}
