import 'package:shared_preferences/shared_preferences.dart';

class AuthHeaders {
  static const String _tokenKey = 'auth_token';

  /// Returns a map with Authorization and Content-Type headers.
  /// Throws an exception if token is missing.
  static Future<Map<String, String>> withBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null || token.trim().isEmpty) {
      throw Exception('⚠️ No auth token found. User may not be logged in.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Returns headers with token if available, otherwise only content-type
  static Future<Map<String, String>> withOptionalToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
