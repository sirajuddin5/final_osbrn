import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../apiCalls/auth_headers.dart';
import '../constants.dart';


class ApiServiceNetwork {
 final String baseUrl = ApiConstants.baseUrl;
 final dio = Dio();

 // General method to make GET requests
 Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? body}) async {
  final headers = await AuthHeaders.withBearerToken();
  // final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers); 

  dio.options.headers = headers;
  // Set Base URL
  dio.options.baseUrl = baseUrl;
  final response = await dio.get(endpoint, data: body);
  return response.data as Map<String, dynamic>;
 }

 // General method to make POST requests
 Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
  final headers = await AuthHeaders.withBearerToken();
  final response = await http.post(Uri.parse('$baseUrl$endpoint'), headers: headers, body: json.encode(body));

  return _handleResponse(response);
 }

 // General method to make DELETE requests
 Future<Map<String, dynamic>> delete(String endpoint) async {
  final headers = await AuthHeaders.withBearerToken();
  final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);

  return _handleResponse(response);
 }

 // General method to make PUT requests
 Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
  final headers = await AuthHeaders.withBearerToken();
  final response = await http.put(Uri.parse('$baseUrl$endpoint'), headers: headers, body: json.encode(body));

  return _handleResponse(response);
 }

 // Handle HTTP responses, throw errors if not 200 OK
 Map<String, dynamic> _handleResponse(http.Response response) {

  if (response.statusCode >= 200 && response.statusCode < 300) {
   return json.decode(response.body);
  } else {
   throw Exception('Failed to load data: ${response.statusCode}');
  }
 }

}
