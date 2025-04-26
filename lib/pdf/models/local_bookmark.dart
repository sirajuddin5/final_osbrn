
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:osborn_book/pdf/models/bookmarks.dart';

part 'local_bookmark.g.dart';

@HiveType(typeId: 5)
class LocalBookmark extends HiveObject {
  @HiveField(0)
  String? id;
  
  @HiveField(1)
  String publicationId;
  
  @HiveField(2)
  int page;
  
  @HiveField(3)
  String? createdAt;

  LocalBookmark({
    this.id,
    required this.publicationId,
    required this.page,
    this.createdAt,
  });
  
  // Convert from app's Bookmark model
  factory LocalBookmark.fromBookmark(Bookmark bookmark) {
    return LocalBookmark(
      id: bookmark.id,
      publicationId: bookmark.publicationId,
      page: bookmark.page,
      createdAt: bookmark.createdAt.toString(),
    );
  }
  
  // Convert to app's Bookmark model
  Bookmark toBookmark() {
    return Bookmark(
      id: id,
      publicationId: publicationId,
      page: page,
      createdAt: DateTime.tryParse(createdAt!),
    );
  }

  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publication_id': publicationId,
      'page': page,
      'created_at': createdAt,
    };
  }
}
