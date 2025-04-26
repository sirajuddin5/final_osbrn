// note_model.dart
class Note {
  final String? id;
  final String publicationId;
  final int page;
  final double x;
  final double y;
  final String color;
  final String text;
  final String? createdAt;

  Note({
    this.id,
    required this.publicationId,
    required this.page,
    required this.x,
    required this.y,
    required this.color,
    required this.text,
    this.createdAt,
  });

  // Factory constructor to create a Note instance from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? null,
      publicationId: json['publication_id'] ?? '',
      page: json['page'] ?? 0,
      x: json['x'] ?? 0.0,
      y: json['y'] ?? 0.0,
      color: json['color'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  // Method to convert a Note instance to a JSON map (for request body)
  Map<String, dynamic> toJson() {
    return {
      'publication_id': publicationId,
      'page': page,
      'x': x,
      'y': y,
      'color': color,
      'text': text,
    };
  }
}
