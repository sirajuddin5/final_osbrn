// //
// //
// // class Publication {
// //   final String urlId;
// //   final String title;
// //   final String description;
// //   final String coverUrl;
// //   final String pathUrl;
// //   final String createdAt;
// //   final String updatedAt;
// //
// //   Publication({
// //     required this.urlId,
// //     required this.title,
// //     required this.description,
// //     required this.coverUrl,
// //     required this.pathUrl,
// //     required this.createdAt,
// //     required this.updatedAt,
// //   });
// //
// //   // factory Publication.fromJson(Map<String, dynamic> json) {
// //   //   return Publication(
// //   //     urlId: json['url_id'],
// //   //     title: json['title'],
// //   //     description: json['description'] ?? "",
// //   //     coverUrl: json['cover_url'],
// //   //     pathUrl: json['path_url'],
// //   //     createdAt: json['created_at'],
// //   //     updatedAt: json['updated_at'],
// //   //   );
// //   // }
// //   factory Publication.fromJson(Map<String, dynamic> json) {
// //     return Publication(
// //       urlId: json['url_id'].toString(), // Ensure url_id is a String
// //       title: json['title'] ?? "",
// //       description: json['description'] ?? "",
// //       coverUrl: json['cover_url'] ?? "",
// //       pathUrl: json['path_url'] ?? "",
// //       createdAt: json['created_at'] ?? "",
// //       updatedAt: json['updated_at'] ?? "",
// //     );
// //   }
// //
// // }
//
//
//
// class Publication {
//   final String urlId;
//   final String title;
//   final String description;
//   final String coverUrl;
//   final String pathUrl;
//   final String createdAt;
//   final String updatedAt;
//   final String urlToPdf;
//
//   Publication({
//     required this.urlId,
//     required this.title,
//     required this.description,
//     required this.coverUrl,
//     required this.pathUrl,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.urlToPdf,
//   });
//
//   factory Publication.fromJson(Map<String, dynamic> json) {
//     return Publication(
//       urlId: json['url_id']?.toString() ?? "", // Ensure url_id is a String
//       title: json['title'] ?? "",
//       description: json['description'] ?? "",
//       coverUrl: json['cover_url'] ?? "",
//       pathUrl: json['path_url'] ?? "",
//       createdAt: json['created_at'] ?? "",
//       updatedAt: json['updated_at'] ?? "",
//       urlToPdf: json['url_to_pdf'] ?? "",
//     );
//   }
// }
//

class Publication {
  final String urlId;
  final String title;
  final String description;
  final String coverUrl;
  final String pathUrl;
  final String createdAt;
  final String updatedAt;
  final String urlToPdf;
  final String flippingBookEmbedCode;

  Publication({
    required this.urlId,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.pathUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.urlToPdf,
    required this.flippingBookEmbedCode,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      urlId: json['urlId']?.toString() ?? "", // Ensure urlId is a String
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      coverUrl: json['cover'] ?? "", // updated key from 'cover_url' to 'cover'
      pathUrl: json['urlPath'] ?? "", // updated key from 'path_url' to 'urlPath'
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
      urlToPdf: json['url_to_pdf'] ?? "",
      flippingBookEmbedCode: json['flipping_book_embed_code'] ?? "", // added new field
    );
  }
}
