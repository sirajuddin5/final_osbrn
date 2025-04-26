import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:osborn_book/authentication/login_page.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';

import '../apiCalls/auth_headers.dart';
import '../constants.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final dio = Dio();

  ApiService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final headers = await AuthHeaders.withBearerToken();
        options.headers = headers;
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          HiveService.deleteDeviceToken();
          // Navigate to Login Screen and pop every other screen.
          Get.offAll(() => const LoginPage());
        }
        handler.next(error);
      },
    ));
  }

  // General method to make GET requests
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? body}) async {
    final headers = await AuthHeaders.withBearerToken();
    // final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);

    log("headers : $headers");
    log("endpoint : $endpoint");
    log("body : $body");

    dio.options.headers = headers;
    // Set Base URL
    dio.options.baseUrl = baseUrl;
    final response = await dio.get(endpoint, data: body);
    log("response : ${response.data}");
    return response.data as Map<String, dynamic>;
  }

  // General method to make POST requests
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final headers = await AuthHeaders.withBearerToken();
    dio.options.headers = headers;
    log("headers : $headers");
    log("endpoint : $endpoint");
    log("body : $body");
    dio.options.baseUrl = baseUrl;
    final response = await dio.post(endpoint, data: body);
    log("response : ${response.data}");
    return response.data as Map<String, dynamic>;
  }

  // General method to make DELETE requests
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final headers = await AuthHeaders.withBearerToken();
    dio.options.headers = headers;
    log("headers : $headers");
    log("endpoint : $endpoint");
    dio.options.baseUrl = baseUrl;
    final response = await dio.delete(endpoint);
    log("response : ${response.data}");
    return response.data as Map<String, dynamic>;
  }

  // General method to make PUT requests
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    final headers = await AuthHeaders.withBearerToken();
    dio.options.headers = headers;
    log("headers : $headers");
    log("endpoint : $endpoint");
    log("body : $body");
    dio.options.baseUrl = baseUrl;
    final response = await dio.put(endpoint, data: body);
    log("response : ${response.data}");
    return response.data as Map<String, dynamic>;
  }
}
