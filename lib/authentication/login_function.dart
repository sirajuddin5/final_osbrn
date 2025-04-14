
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:osborn_book/token/tokens.dart';

import '../shared_prefrences/token_storage.dart';

class AuthResponse {
  final String message;
  final String deviceToken;
  final String statusCode;
  final String error;


  AuthResponse(  {required this.message, required this.deviceToken,required this.statusCode,required this.error});
}

Future authenticateUser(String username, String password, String deviceId) async {
 // final url = 'https://test-api-rho-umber.vercel.app/api/auth/get_device_token';
  final url = 'https://osborne-server.onrender.com/api/v1/auth/login';

  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'password': password,
    'deviceId': deviceId,
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print("response : $response");
    print("response : $response");

    if (response.statusCode == 200) {
      // Successfully authenticated
      print("status code 200");
      final responseData = json.decode(response.body);
      final deviceTokenData = responseData['data'];
      String deviceToken = deviceTokenData['deviceToken'];

      await TokenStorage.saveToken(deviceToken);
      print("device token :"+deviceToken);
      deviceTokenUniversal = deviceToken;
      String message = responseData['status'].toString();
      print('Authentication successful: $message');
      return AuthResponse(message: message, deviceToken: deviceToken, statusCode: '200', error: 'no error' , );
    } else {
      print('Authentication failed: ${response.statusCode}');
      return AuthResponse(message: "some Error", deviceToken: '', error: "error", statusCode: response.statusCode.toString());
    }
  } catch (e) {
    print('An error occurred: $e');
    return AuthResponse(message: "some Error", deviceToken: '', error: e.toString(), statusCode: '');
  }
}
//
//
// //////////////////////////below code is completly fine and working
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthResponse {
//   final String message;
//   final String deviceToken;
//   final String statusCode;
//   final String error;
//   final String? expired;
//
//
//   AuthResponse(   {required this.message, required this.deviceToken,required this.statusCode,required this.error,  this.expired});
// }
//
// Future<void> _saveAuthToken(String token) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('auth_token', token);
// }
//
// Future<void> _saveAuthStatus(bool isLoggedIn) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('is_logged_in', isLoggedIn);
// }
//
// Future<void> _saveExpiredAt(String expired) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('expired_at', expired);
// }
//
// Future<AuthResponse?> authenticateUser(String username, String password, String deviceId) async {
//   final url = 'https://test-api-rho-umber.vercel.app/api/auth/get_device_token';
//   final headers = {'Content-Type': 'application/json'};
//   final body = json.encode({
//     'username': username,
//     'password': password,
//     'deviceId': deviceId,
//   });
//
//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: body,
//     );
//     print(json.decode(response.body));
//     print("inside try block");
//     print(response.statusCode);
//     final responseData = json.decode(response.body);
//     String message = responseData['status'].toString();
//     String deviceToken = responseData['deviceToken'];
//     print("message"+message);
//     print("device TOken"+deviceToken);
//     if (response.statusCode == 200) {
//       // Successfully authenticated
//       final responseData = json.decode(response.body);
//       String message = responseData['status'].toString();
//       String deviceToken = responseData['deviceToken'];
//       print("message"+message);
//       await _saveAuthToken(deviceToken);
//       await _saveAuthStatus(true);
//
//       print('Authentication successful: $deviceToken');
//       return AuthResponse(message: message, deviceToken: deviceToken, statusCode: '200', error: 'no error' , );
//
//     } else {
//       print('Authentication failed: ${response.statusCode}');
//       return AuthResponse(message: "Authentication failed ", deviceToken: '', error: "error", statusCode: response.statusCode.toString());
//       // Return null or handle error based on status code
//     }
//   } catch (e) {
//     print("outside try block try block");
//     print('An error occurred: $e');
//     return AuthResponse(message: "some Error occured", deviceToken: '', error: e.toString(), statusCode: '');
// // Return null or handle error
//   }
// }


///////////////////////////////////////////changes
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthResponse {
//   final String deviceToken;
//   final String statusCode;
//   final String error;
//   final int? expired;
//
//   AuthResponse({
//     required this.deviceToken,
//     required this.statusCode,
//     required this.error,
//     this.expired,
//   });
// }
//
// Future<void> _saveAuthToken(String token) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('auth_token', token);
// }
//
// Future<void> _saveAuthStatus(bool isLoggedIn) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('is_logged_in', isLoggedIn);
// }
//
// Future<void> _saveExpiredAt(int expired) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setInt('expired_at', expired);
// }
//
// Future<AuthResponse?> authenticateUser(String username, String password, String deviceId) async {
//   // Encode the credentials as base64
//   String credentials = '$username:$password';
//   String base64EncodedCredentials = base64.encode(utf8.encode(credentials));
//
//   // Create the Authorization header
//   String authHeader = 'Basic $base64EncodedCredentials';
//
//   final url = 'https://www.osbornebooks.co.uk/api/get_auth_token';
//
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': authHeader,
//   };
//
//   // Log headers and URL for debugging
//   print("Request URL: $url");
//   print("Request Headers: $headers");
//
//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: headers,
//     );
//
//     // Log response status and body
//     print("Response Status Code: ${response.statusCode}");
//     print("Response Body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       // Parse response data
//       final responseData = json.decode(response.body);
//
//       // Check if 'token' and 'expired' fields are present
//       String deviceToken = responseData['token'] ?? '';
//       int expiredAt = responseData['expired'] ?? 0;
//
//       print("Device Token: $deviceToken");
//       print("Expired At: $expiredAt");
//
//       if (deviceToken.isNotEmpty) {
//         // Save token and other details
//         await _saveAuthToken(deviceToken);
//         await _saveAuthStatus(true);
//         await _saveExpiredAt(expiredAt);
//
//         print('Authentication successful: $deviceToken');
//         return AuthResponse(
//           deviceToken: deviceToken,
//           statusCode: '200',
//           error: 'no error',
//           expired: expiredAt,
//         );
//       } else {
//         // Handle case where token is not present (invalid login)
//         print('Authentication failed: No token returned.');
//         return AuthResponse(
//           deviceToken: '',
//           statusCode: '200',
//           error: 'Invalid credentials. No token returned.',
//         );
//       }
//     } else {
//       print('Authentication failed: ${response.statusCode}');
//       return AuthResponse(
//         deviceToken: '',
//         statusCode: response.statusCode.toString(),
//         error: "Authentication failed. Status code: ${response.statusCode}",
//       );
//     }
//   } catch (e) {
//     // Log the error if an exception occurs
//     print("Exception caught during HTTP request: $e");
//     return AuthResponse(
//       deviceToken: '',
//       statusCode: '',
//       error: e.toString(),
//     );
//   }
// }
