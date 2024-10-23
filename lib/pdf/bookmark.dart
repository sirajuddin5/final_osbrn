class Bookmark {
  String id;
  int pageNumber;

  Bookmark({required this.id, required this.pageNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page': pageNumber,
    };
  }
}