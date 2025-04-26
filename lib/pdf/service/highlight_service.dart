import 'dart:convert';
import 'dart:developer';

import 'package:osborn_book/pdf/models/base_response_model.dart';
import 'package:osborn_book/pdf/models/local_highlight.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';

import '../apiCalls/auth_headers.dart';
import '../models/highlights.dart';
import 'api_service.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class HighlightService {
  final ApiService _apiService = ApiService();

  // Create a new Highlight (POST)
  Future<BaseResponseModel<Highlight>> createHighlight(
      Highlight highlight) async {
    final response = await _apiService.post(
      ApiConstants.highlightsEndpoint,
      highlight.toJson(),
    );
    log("========create highlight =========");
    log(response.toString());

    // Simultaneously save to local storage
    BaseResponseModel<Highlight> responseModel =
        BaseResponseModel<Highlight>.fromJson(response);
    if (responseModel.status == true && responseModel.data != null) {
      try {
        // Create PdfTextLineLocal objects from the highlight text lines
        List<PdfTextLineLocal> textLines = [];
        for (var line in highlight.pdfTextLines) {
          textLines.add(PdfTextLineLocal(
            x: line['x'] as double,
            y: line['y'] as double,
            width: line['width'] as double,
            height: line['height'] as double,
            text: line['text'] as String,
            pageNumber: line['pageNumber'] as int,
          ));
        }

        // Create LocalHighlight object
        final localHighlight = LocalHighlight(
          id: responseModel.data!.id,
          publicationReaderId: highlight.publicationReaderId,
          pdfTextLines: textLines,
        );

        // Save to Hive
        await HiveService.saveHighlight(
            highlight.publicationReaderId, localHighlight);
      } catch (e) {
        log("Error saving highlight locally: $e");
      }
    }

    return responseModel;
  }

  // Get all Highlights (GET)
  Future<BaseResponseModel<List<Highlight>>> getHighlights(
      String publicationId) async {
    final response = await _apiService.get(
      '${ApiConstants.highlightsEndpoint}/$publicationId',
    );
    log("========get highlights =========");
    log(response.toString());
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
