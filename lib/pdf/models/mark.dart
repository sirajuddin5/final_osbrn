// mark_model.dart
class Mark {
  final String id;
  final String publicationReaderId;
  final int page;
  final double x;
  final double y;

  Mark({
    required this.id,
    required this.publicationReaderId,
    required this.page,
    required this.x,
    required this.y,
  });

  // Factory constructor to create a Mark from JSON (response)
  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      id: json['id'],
      publicationReaderId: json['publication_reader_id'],
      page: json['page'],
      x: json['x'],
      y: json['y'],
    );
  }

  // Method to convert a Mark object into JSON (for request body)
  Map<String, dynamic> toJson() {
    return {
      'publicationId': publicationReaderId, // or 'publicationId' as per request format
      'page': page,
      'x': x,
      'y': y,
    };
  }
}
