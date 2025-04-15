// adjust based on your project structure
import 'package:osborn_book/pdf/models/base_response_model.dart';

import '../models/notes.dart';
import 'api_service.dart';
import '../constants.dart';

class NoteService {
  final ApiServiceNetwork _apiService = ApiServiceNetwork();

  // Create a new Note (POST)
  Future<BaseResponseModel<Note>> createNote(Note note) async {
    final response = await _apiService.post(
      ApiConstants.notesEndpoint,
      note.toJson(),
    );
    return BaseResponseModel<Note>.fromJson(response);
  }

  // Get all Notes for a publication (GET)
  Future<BaseResponseModel<List<Note>>> getNotes(String publicationId) async {
    final response = await _apiService.get(
      '${ApiConstants.notesEndpoint}?publication_id=$publicationId',
    );

    return BaseResponseModel<List<Note>>.fromJson(response);
  }

  // Update an existing Note (PUT)
  Future<BaseResponseModel<Note>> updateNote(String id, Note note) async {
    final response = await _apiService.put(
      '${ApiConstants.notesEndpoint}/$id',
      note.toJson(),
    );
    return BaseResponseModel<Note>.fromJson(response);
  }

  // Delete a Note (DELETE)
  Future<void> deleteNote(String id) async {
    final response = await _apiService.delete(
      '${ApiConstants.notesEndpoint}/$id',
    );
    // Optionally handle the response if you need confirmation or data
    if (response['status'] != 'success') {
      throw Exception('Failed to delete note');
    }
  }
}
