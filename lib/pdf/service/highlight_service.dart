import 'dart:convert';
import 'dart:developer';

import 'package:osborn_book/pdf/models/base_response_model.dart';

import '../apiCalls/auth_headers.dart';
import '../models/highlights.dart';
import 'api_service.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class HighlightService {
  final ApiServiceNetwork _apiService = ApiServiceNetwork();

  // Create a new Highlight (POST)
  Future<BaseResponseModel<Highlight>> createHighlight(
      Highlight highlight) async {
    final response = await _apiService.post(
      ApiConstants.highlightsEndpoint,
      highlight.toJson(),
    );
    print("========create highlight =========");
    print(response);
    return BaseResponseModel<Highlight>.fromJson(response);
  }

  // Get all Highlights (GET)
  Future<BaseResponseModel<List<Highlight>>> getHighlights(
      String publicationId) async {
    final response = await _apiService.get(
      '${ApiConstants.highlightsEndpoint}/$publicationId',
    );

    return BaseResponseModel<List<Highlight>>.fromJson(response);
  }

  Future<BaseResponseModel<Highlight>> getHighlightByPage(
      String publicationId, int page) async {
    try {
      final headers =
          await AuthHeaders.withBearerToken(); // Get headers with token
      var request = http.Request(
          'GET',
          Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.highlightsEndpoint}/$publicationId/page/$page'));

      // Add Authorization headers
      request.headers.addAll(headers);

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // If the request is successful, parse the response body
        String responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody); // Convert to JSON
        return BaseResponseModel<Highlight>.fromJson(
            data); // Parse it into a Highlight model
      } else {
        throw Exception(
            'Failed to load highlight on page $page: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception(
          'Error occurred while fetching highlight on page $page: $e');
    }
  }

  // Update an existing Highlight (PUT)
  // Future<BaseResponseModel<Highlight>> updateHighlight(String id, Highlight highlight) async {
  //   final response = await _apiService.put(
  //     '${ApiConstants.highlightsEndpoint}/$id',
  //     highlight.toJson(),
  //   );
  //   return BaseResponseModel<Highlight>.fromJson(response);
  // }

  // Delete a Highlight (DELETE)
  Future<void> deleteHighlight(String id) async {
    final response = await _apiService.delete(
      '${ApiConstants.highlightsEndpoint}/$id',
    );

    log(response.toString());
    // Optionally handle the response if you need confirmation or data
    if (response['status'] != true) {
      throw Exception('Failed to delete highlight');
    }
  }
}
