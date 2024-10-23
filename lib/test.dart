// //
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// //
// // import 'package:http/http.dart' as http;
// //
// // class ApiService {
// //   final String _baseUrl = 'https://www.osbornebooks.co.uk/api/ebook/ABT_2020/';
// //   final String _token = '73fa85773365e5d2ce858b418bfe50ce';
// //
// //   Future<String> fetchData() async {
// //     final response = await http.get(
// //       Uri.parse(_baseUrl),
// //       headers: {
// //         'Authorization': 'token $_token',
// //       },
// //
// //     );
// //
// //     if (response.statusCode == 200) {
// //       // Return the body of the response
// //       return response.body;
// //     } else {
// //       print(response);
// //       // Handle the error
// //       throw Exception('Failed to load data');
// //     }
// //   }
// // }
// //
// // class EbookScreen extends StatefulWidget {
// //   @override
// //   _EbookScreenState createState() => _EbookScreenState();
// // }
// //
// // class _EbookScreenState extends State<EbookScreen> {
// //   late Future<String> _data;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _data = ApiService().fetchData();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Ebook Data'),
// //       ),
// //       body: FutureBuilder<String>(
// //         future: _data,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (snapshot.hasData) {
// //             // Display the data
// //             return SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Text(
// //                   snapshot.data!,
// //                   style: TextStyle(fontSize: 16),
// //                 ),
// //               ),
// //             );
// //           } else {
// //             return Center(child: Text('No data found'));
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// //
// // //
// // // class EbookScreen extends StatefulWidget {
// // //   @override
// // //   _EbookScreenState createState() => _EbookScreenState();
// // // }
// // //
// // // class _EbookScreenState extends State<EbookScreen> {
// // //   late Future<String> _data;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _data = ApiService().fetchData();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Ebook Content'),
// // //       ),
// // //       body: FutureBuilder<String>(
// // //         future: _data,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(child: CircularProgressIndicator());
// // //           } else if (snapshot.hasError) {
// // //             return Center(child: Text('Error: ${snapshot.error}'));
// // //           } else if (snapshot.hasData) {
// // //             return SingleChildScrollView(
// // //               child: Html(
// // //                 data: snapshot.data,
// // //                 style: {
// // //                   "html": Style(
// // //                     fontSize: FontSize.large,
// // //                     backgroundColor: Colors.white,
// // //                     color: Colors.black,
// // //                   ),
// // //                   "h1": Style(
// // //                     fontSize: FontSize.xLarge,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                   "p": Style(
// // //                     fontSize: FontSize.medium,
// // //                     margin: EdgeInsets.symmetric(vertical: 8),
// // //                   ),
// // //                 },
// // //               ),
// // //             );
// // //           } else {
// // //             return Center(child: Text('No data found'));
// // //           }
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:webview_flutter/webview_flutter.dart';
//
// class ApiService {
//   final String _baseUrl = 'https://www.osbornebooks.co.uk/api/ebook/ABT_2020/';
//   final String _token = '73fa85773365e5d2ce858b418bfe50ce';
//
//   Future<String> fetchData() async {
//     final response = await http.get(
//       Uri.parse(_baseUrl),
//       headers: {
//         'Authorization': 'token $_token',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // Return the body of the response
//       return response.body;
//     } else {
//       // Handle the error
//       throw Exception('Failed to load data');
//     }
//   }
// }
//
// class EbookScreen extends StatefulWidget {
//   @override
//   _EbookScreenState createState() => _EbookScreenState();
// }
//
// class _EbookScreenState extends State<EbookScreen> {
//   late Future<String> _data;
//   WebViewController controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(const Color(0x00000000))
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//         },
//         onPageStarted: (String url) {},
//         onPageFinished: (String url) {},
//         onHttpError: (HttpResponseError error) {},
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url.startsWith('https://www.youtube.com/')) {
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse('https://flutter.dev'));
//
//   @override
//   void initState() {
//     super.initState();
//     _data = ApiService().fetchData();
//
//     // Ensure WebView is initialized for iOS
//     if (controller.platform is AndroidViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ebook Data'),
//       ),
//       body: FutureBuilder<String>(
//         future: _data,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return WebViewWidget(
//               initialUrl: Uri.dataFromString(
//                 snapshot.data!,
//                 mimeType: 'text/html',
//                 encoding: Encoding.getByName('utf-8'),
//               ).toString(),
//               javascriptMode: JavascriptMode.unrestricted,
//               navigationDelegate: (NavigationRequest request) {
//                 if (request.url.startsWith('http')) {
//                   // Handle navigation to external links if needed
//                   return NavigationDecision.navigate;
//                 }
//                 return NavigationDecision.prevent;
//               },
//             );
//           } else {
//             return Center(child: Text('No data found'));
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class ApiService {
  final String baseUrl = 'https://www.osbornebooks.co.uk/api/ebook/ABT_2020/';
  final String token = '73fa85773365e5d2ce858b418bfe50ce';

  Future<String> fetchData() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class EbookScreen extends StatefulWidget {
  @override
  _EbookScreenState createState() => _EbookScreenState();
}

class _EbookScreenState extends State<EbookScreen> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest (
      Uri.parse('https://www.osbornebooks.co.uk/api/ebook/ABT_2020/'),
      headers: {
        'Authorization': 'token 73fa85773365e5d2ce858b418bfe50ce',
      },
    );

  @override
  void initState() {
    super.initState();
    // Ensure WebView is initialized for iOS
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ebook Data'),
        ),
        body: WebViewWidget(controller: controller));
  }
}
