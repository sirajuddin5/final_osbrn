
import '../constants.dart';
import '../models/bookmarks.dart';
import 'api_service.dart';

class BookmarkService {
  final ApiServiceNetwork _apiService = ApiServiceNetwork();

  // Create a new Bookmark (POST)
  Future<Bookmark> createBookmark(Bookmark bookmark) async {
    final response = await _apiService.post(ApiConstants.bookmarksEndpoint, bookmark.toJson());
    return Bookmark.fromJson(response);
  }

  // Get all Bookmarks (GET)
  Future<List<Bookmark>> getBookmarks() async {
    final response = await _apiService.get(ApiConstants.bookmarksEndpoint);
    List<dynamic> data = response['data'] ?? [];
    return data.map((item) => Bookmark.fromJson(item)).toList();
  }

  // Delete a Bookmark (DELETE)
  Future<void> deleteBookmark(int id) async {
    final response = await _apiService.delete('${ApiConstants.bookmarksEndpoint}/$id');
    // Optionally handle the response if you need confirmation or data
    if (response['status'] != 'success') {
      throw Exception('Failed to delete bookmark');
    }
  }
}
