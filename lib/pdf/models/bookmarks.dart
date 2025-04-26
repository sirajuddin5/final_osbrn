// bookmark_model.dart
class Bookmark {
  final String? id;
  final int page;
  final String publicationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Bookmark({required this.page, required this.publicationId, this.id, this.createdAt, this.updatedAt});

  // Factory constructor to create a Bookmark instance from JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      page: json['page'] ?? 0,
      publicationId: json['publication_id'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Method to convert a Bookmark instance to a JSON map (for request body)
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'page': page,
      'publication_id': publicationId,
      // 'created_at': createdAt?.toIso8601String(),
      // 'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
