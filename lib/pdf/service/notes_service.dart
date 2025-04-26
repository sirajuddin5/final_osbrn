// adjust based on your project structure
import 'dart:developer';
import 'package:osborn_book/pdf/models/base_response_model.dart';
import 'package:osborn_book/pdf/models/local_note.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';

import '../models/notes.dart';
import 'api_service.dart';
import '../constants.dart';

class NoteService {
  final ApiService _apiService = ApiService();

  // Create a new Note (POST)
  Future<BaseResponseModel<Note>> createNote(Note note) async {
    final response = await _apiService.post(
      ApiConstants.notesEndpoint,
      note.toJson(),
    );

    // Simultaneously save to local storage
    BaseResponseModel<Note> responseModel =
        BaseResponseModel<Note>.fromJson(response);
    if (responseModel.status == true && responseModel.data != null) {
      try {
        // Create LocalNote from returned note
        final localNote = LocalNote.fromNote(responseModel.data!);

        // Save to Hive
        await HiveService.saveNote(note.publicationId, localNote);
      } catch (e) {
        log("Error saving note locally: $e");
      }
    }

    return responseModel;
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

    // Simultaneously update in local storage
    BaseResponseModel<Note> responseModel =
        BaseResponseModel<Note>.fromJson(response);
    if (responseModel.status == true && responseModel.data != null) {
      try {
        // Create LocalNote from returned note
        final localNote = LocalNote.fromNote(responseModel.data!);

        // Save to Hive
        await HiveService.saveNote(note.publicationId, localNote);
      } catch (e) {
        log("Error updating note locally: $e");
      }
    }

    return responseModel;
  }

  // Delete a Note (DELETE)
  Future<void> deleteNote(String id, String publicationId) async {
    final response = await _apiService.delete(
      '${ApiConstants.notesEndpoint}/$id',
    );

    // Also delete from local storage if server delete was successful
    try {
      await HiveService.deleteNote(publicationId, id);
    } catch (e) {
      log("Error deleting note locally: $e");
    }
  }
}
