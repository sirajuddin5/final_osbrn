import 'package:osborn_book/pdf/models/base_response_model.dart';

import '../constants.dart';
import '../models/bookmarks.dart';
import 'api_service.dart';

class BookmarkService {
  final ApiServiceNetwork _apiService = ApiServiceNetwork();

  // Create a new Bookmark (POST)
  Future<BaseResponseModel<Bookmark>> createBookmark(Bookmark bookmark) async {
    final response = await _apiService.post(
        ApiConstants.bookmarksEndpoint, bookmark.toJson());
    return BaseResponseModel<Bookmark>.fromJson(response);
  }

  // Get all Bookmarks (GET)
  Future<BaseResponseModel<List<Bookmark>>> getBookmarks(
      String publicationId) async {
    final response = await _apiService.get(
      ApiConstants.bookmarksEndpoint,
      body: {'publication_id': publicationId},
    );

    return BaseResponseModel<List<Bookmark>>.fromJson(response);
  }

  // Delete a Bookmark (DELETE)
  Future<void> deleteBookmark(String id) async {
    final response =
        await _apiService.delete('${ApiConstants.bookmarksEndpoint}/$id');
    // Optionally handle the response if you need confirmation or data
  }
}
