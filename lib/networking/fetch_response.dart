// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:osborn_book/main.dart';
// import 'package:osborn_book/networking/publication_model.dart';
// //
// // Future<List<Publication>> fetchPublications() async {
// //   print("fetch publication being called");
// //
// //   final response = await http.get(Uri.parse('https://test-api-rho-umber.vercel.app/api/testPub'));
// //   print("response recieved");
// //   print(response);
// //
// //   if (response.statusCode == 200) {
// //     final jsonResponse = jsonDecode(response.body);
// //     print(jsonResponse);
// //     final publicationsJson = jsonResponse['result'] as List;
// //     return publicationsJson.map((json) => Publication.fromJson(json)).toList();
// //   } else {
// //     throw Exception('Failed to load publications');
// //   }
// // }
//
// // Future<List<Publication>> fetchPublications() async {
// //   print("fetch publication being called");
// //
// //   final response = await http.get(Uri.parse('https://test-api-rho-umber.vercel.app/api/testPub'));
// //   print("response received");
// //   print(response);
// //
// //   if (response.statusCode == 200) {
// //     final jsonResponse = jsonDecode(response.body);
// //     print(jsonResponse);
// //     final publicationsJson = jsonResponse['result'] as List;
// //     return publicationsJson.map((json) => Publication.fromJson(json)).toList();
// //   } else {
// //     throw Exception('Failed to load publications');
// //   }
// // }
//
//
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:osborn_book/networking/publication_model.dart';
// //
// // Future<List<Publication>> fetchPublications() async {
// //   print("Fetching publications...");
// //
// //   try {
// //     final response = await http.get(Uri.parse('https://test-api-rho-umber.vercel.app/api/testPub'));
// //
// //     print("Response received with status code: ${response.statusCode}");
// //     print(response);
// //
// //     if (response.statusCode == 200) {
// //       final jsonResponse = jsonDecode(response.body);
// //
// //       // Check if 'result' is present and is a List
// //       if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('result') && jsonResponse['result'] is List) {
// //         final publicationsJson = jsonResponse['result'] as List;
// //         return publicationsJson.map((json) => Publication.fromJson(json)).toList();
// //       } else {
// //         throw Exception('Unexpected JSON structure');
// //       }
// //     } else {
// //       throw Exception('Failed to load publications: ${response.statusCode}');
// //     }
// //   } catch (e) {
// //     print('Error occurred: $e');
// //     throw Exception('Failed to load publications: $e');
// //   }
// // }
// ////////////////// the original one
// Future<List<Publication>> fetchPublications(String token) async {
//   print("fetch publication being called");
//   String dToken = await getDeviceToken().toString();
//   print(token);
//
//   final url = 'https://www.osbornebooks.co.uk/api/publications';
//   final headers = {
//     'Content-Type': 'application/json',
//     // 'Authorization': 'Bearer $token',
//     // 'Authorization': 'Bearer $token',
//     'Authorization': 'token 0fc29660c2d5b9f97f26f3fdb7fd367Z',
//   };
//
//   try{
//     final response = await http.get(Uri.parse(url), headers: headers);
//
//     print("Response received with status: ${response.statusCode}");
//
//
//   // final response = await http.get(Uri.parse('https://test-api-rho-umber.vercel.app/api/testPub'));
//   // print("response received");
//   // print(response);
//
//   if (response.statusCode == 200) {
//     final jsonResponse = jsonDecode(response.body);
//     print(jsonResponse);
//     final List<dynamic> publicationsJson = jsonResponse; // List<dynamic> instead of Map
//     return publicationsJson.map((json) => Publication.fromJson(json as Map<String, dynamic>)).toList();
//   } else {
//     throw Exception('Failed to load publications');
//   }
//   }catch(e){
//     print("error occured");
//     throw Exception('failed to load publication');
//   }
// }
//
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:osborn_book/main.dart';
// import 'package:osborn_book/networking/publication_model.dart';
// Future<List<Publication>> fetchPublications(String token) async {
//   print("fetch publication being called");
//
//   // Ensure you retrieve the device token correctly
//   // String dToken = await getDeviceToken();
//   // print("Device Token: $dToken");
//
//   final url = 'https://www.osbornebooks.co.uk/api/publications';
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'token 0fc29660c2d5b9f97f26f3fdb7fd367Z',
//   };
//
//   try {
//     final response = await http.get(Uri.parse(url), headers: headers);
//
//     print("Response received with status: ${response.statusCode}");
//
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       print(jsonResponse); // For debugging
//
//       // Access the 'results' key to get the list of publications
//       final List<dynamic> publicationsJson = jsonResponse['results'] ?? [];
//       return publicationsJson
//           .map((json) => Publication.fromJson(json as Map<String, dynamic>))
//           .toList();
//     } else {
//       print("Error: ${response.body}"); // Print the error response for debugging
//       throw Exception('Failed to load publications: ${response.reasonPhrase}');
//     }
//   }
//   catch (e) {
//     print("Error occurred: $e"); // Print the actual error
//     throw Exception('Failed to load publications: $e');
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:osborn_book/main.dart';
import 'package:osborn_book/networking/publication_model.dart';

import '../pdf/downloaded_pdf_list.dart';

Future<List<Publication>> fetchPublications(String token, BuildContext context) async {
  print("fetch publication being called");

  final url = 'https://www.osbornebooks.co.uk/api/publications';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'token 0fc29660c2d5b9f97f26f3fdb7fd367Z',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    print("Response received with status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse); // For debugging

      // Access the 'results' key to get the list of publications
      final List<dynamic> publicationsJson = jsonResponse['results'] ?? [];
      return publicationsJson
          .map((json) => Publication.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      print("Error: ${response.body}"); // Print the error response for debugging
      throw Exception('Failed to load publications: ${response.reasonPhrase}');
    }
  } on SocketException catch (e) {
    print('Network error: $e');

    throw Exception('No internet connection');
    // Show the no internet dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return NoInternetDialog(onReload: (){
    //       Navigator.pop(context);
    //       fetchPublications(token, context);
    //     },);
    //   },
    // );
    // return []; // Return an empty list on error
  } catch (e) {
    print("Error occurred: $e"); // Print the actual error
    throw Exception('Failed to load publications: $e');
  }
}

class NoInternetDialog extends StatelessWidget {
  final VoidCallback onReload;

  const NoInternetDialog({required this.onReload});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("No Internet Connection"),
      content: Text("Please check your internet connection and try again."),
      actions: <Widget>[
        TextButton(
          child: Text("Go to Download"),
          onPressed: ()  {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DownloadedPdfsPage()),
            );

          },
        ),
        TextButton(
          child: Text("Reload"),
          onPressed: onReload,
        ),
      ],
    );
  }
}
