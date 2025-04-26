import 'dart:developer';
import 'package:osborn_book/pdf/models/base_response_model.dart';
import 'package:osborn_book/pdf/models/local_bookmark.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';

import '../constants.dart';
import '../models/bookmarks.dart';
import 'api_service.dart';

class BookmarkService {
  final ApiService _apiService = ApiService();

  // Create a new Bookmark (POST)
  Future<BaseResponseModel<Bookmark>> createBookmark(Bookmark bookmark) async {
    final response = await _apiService.post(
        ApiConstants.bookmarksEndpoint, bookmark.toJson());

    // Simultaneously save to local storage
    BaseResponseModel<Bookmark> responseModel =
        BaseResponseModel<Bookmark>.fromJson(response);
    if (responseModel.status == true && responseModel.data != null) {
      try {
        // Create LocalBookmark from returned bookmark
        final localBookmark = LocalBookmark(
          id: responseModel.data!.id,
          publicationId: bookmark.publicationId,
          page: bookmark.page,
          createdAt: DateTime.now().toString(),
        );

        // Save to Hive
        await HiveService.saveBookmark(bookmark.publicationId, localBookmark);
      } catch (e) {
        log("Error saving bookmark locally: $e");
      }
    }

    return responseModel;
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
  Future<void> deleteBookmark(String id, String publicationId) async {
    final response =
        await _apiService.delete('${ApiConstants.bookmarksEndpoint}/$id');

    // Also delete from local storage if server delete was successful
    try {
      await HiveService.deleteBookmark(publicationId, id);
    } catch (e) {
      log("Error deleting bookmark locally: $e");
    }
  }
}
