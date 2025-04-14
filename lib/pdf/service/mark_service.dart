import '../models/mark.dart';
import 'api_service.dart';
import '../constants.dart';

class MarkService {
  final ApiServiceNetwork _apiService = ApiServiceNetwork();

  // Create a new Mark (POST)
  Future<Mark> createMark(Mark mark) async {
    final response = await _apiService.post(
      ApiConstants.marksEndpoint,
      mark.toJson(),
    );
    return Mark.fromJson(response);
  }

  // Get all Marks for a publication reader (GET)
  Future<List<Mark>> getMarks(String publicationReaderId) async {
    final response = await _apiService.get(
      '${ApiConstants.marksEndpoint}?publication_reader_id=$publicationReaderId',
    );
    List<dynamic> data = response['data'] ?? [];
    return data.map((item) => Mark.fromJson(item)).toList();
  }

  // Update an existing Mark (PUT)
  Future<Mark> updateMark(String id, Mark mark) async {
    final response = await _apiService.put(
      '${ApiConstants.marksEndpoint}/$id',
      mark.toJson(),
    );
    return Mark.fromJson(response);
  }

  // Delete a Mark (DELETE)
  Future<void> deleteMark(String id) async {
    final response = await _apiService.delete(
      '${ApiConstants.marksEndpoint}/$id',
    );
    // Optionally handle the response if you need confirmation or data
    if (response['status'] != 'success') {
      throw Exception('Failed to delete mark');
    }
  }
}
