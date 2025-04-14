// bookmark_model.dart
class Bookmark {
  final int page;
  final String publicationId;

  Bookmark({required this.page, required this.publicationId});

  // Factory constructor to create a Bookmark instance from JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      page: json['page'] ?? 0,
      publicationId: json['publication_id'] ?? '',
    );
  }

  // Method to convert a Bookmark instance to a JSON map (for request body)
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'publication_id': publicationId,
    };
  }
}
