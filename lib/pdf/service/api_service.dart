import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../apiCalls/auth_headers.dart';
import '../constants.dart';

class ApiServiceNetwork {
  final String baseUrl = ApiConstants.baseUrl;
  final dio = Dio();

  // General method to make GET requests
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? body}) async {
    final headers = await AuthHeaders.withBearerToken();
    dio.options.headers = headers;
    // Set Base URL
    dio.options.baseUrl = baseUrl;
    log("Headers: $headers");
    log("Endpoint: $endpoint");
    log("Body: $body");
    final response = await dio.get(endpoint, data: body);
    log("Response from get: ${response.data}");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    return response.data as Map<String, dynamic>;
  }

  // General method to make POST requests
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final headers = await AuthHeaders.withBearerToken();
    dio.options.headers = headers;
    // Set Base URL
    dio.options.baseUrl = baseUrl;
    log("Headers: $headers");
    log("Endpoint: $endpoint");
    log("Body: $body");
    final response = await dio.post(endpoint, data: body);
    log("Response from post: ${response.data}");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    return response.data as Map<String, dynamic>;
  }

  // General method to make DELETE requests
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final headers = await AuthHeaders.withBearerToken();
    dio.options.headers = headers;
    // Set Base URL
    dio.options.baseUrl = baseUrl;
    log("Headers: $headers");
    log("Endpoint: $endpoint");
    final response = await dio.delete(endpoint);
    log("Response from delete: ${response.data}");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    return response.data as Map<String, dynamic>;
  }

  // General method to make PUT requests
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    final headers = await AuthHeaders.withBearerToken();
    dio.options.headers = headers;
    // Set Base URL
    dio.options.baseUrl = baseUrl;
    log("Headers: $headers");
    log("Endpoint: $endpoint");
    log("Body: $body");
    final response = await dio.put(endpoint, data: body);
    log("Response from put: ${response.data}");
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    return response.data as Map<String, dynamic>;
  }
}
