// // import 'package:flutter/material.dart';
// //
// // import 'networking/fetch_response.dart';
// // import 'networking/publication_model.dart';
// //
// // class PublicationsScreen extends StatefulWidget {
// //   @override
// //   _PublicationsScreenState createState() => _PublicationsScreenState();
// // }
// //
// // class _PublicationsScreenState extends State<PublicationsScreen> {
// //   late Future<List<Publication>> futurePublications;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     futurePublications = fetchPublications();
// //     print("inside the init state");
// //     print(futurePublications);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Publications'),
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //
// //           FutureBuilder<List<Publication>>(
// //             future: futurePublications,
// //             builder: (context, snapshot) {
// //               if (snapshot.hasData) {
// //                 return ListView.builder(
// //                   itemCount: snapshot.data?.length,
// //                   itemBuilder: (context, index) {
// //                     final publication = snapshot.data![index];
// //                     print(publication);
// //                     return ListTile(
// //                       leading: Image.network(publication.coverUrl),
// //                       title: Text(publication.title),
// //                       subtitle: Text(publication.createdAt),
// //                       onTap: () {
// //                         // Implement navigation to a detailed view or external URL
// //                       },
// //                     );
// //                   },
// //                 );
// //               } else if (snapshot.hasError) {
// //                 return Center(child: Text("Error: ${snapshot.error}"));
// //               }
// //
// //               return Center(child: CircularProgressIndicator());
// //             },
// //           ),
// //           const SizedBox(
// //            height: 50,
// //           ),
// //           TextButton(
// //             child: Text('SignUp', style: TextStyle(fontSize: 20.0),),
// //             onPressed: () {
// //               futurePublications = fetchPublications();
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
//
// import 'networking/fetch_response.dart';
// import 'networking/publication_model.dart';
//
// class PublicationsScreen extends StatefulWidget {
//   @override
//   _PublicationsScreenState createState() => _PublicationsScreenState();
// }
//
// class _PublicationsScreenState extends State<PublicationsScreen> {
//   late Future<List<Publication>> futurePublications;
//
//   @override
//   void initState() {
//     super.initState();
//     futurePublications = fetchPublications();
//     print("inside the init state");
//     print(futurePublications);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Publications'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: FutureBuilder<List<Publication>>(
//               future: futurePublications,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     itemCount: snapshot.data?.length,
//                     itemBuilder: (context, index) {
//                       final publication = snapshot.data![index];
//                       print(publication);
//                       return ListTile(
//                         leading: Image.network(publication.coverUrl),
//                         title: Text(publication.title),
//                         subtitle: Text(publication.createdAt),
//                         onTap: () {
//                           // Implement navigation to a detailed view or external URL
//                         },
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 }
//
//                 return Center(child: CircularProgressIndicator());
//               },
//             ),
//           ),
//
//           TextButton(
//             child: Text('SignUp', style: TextStyle(fontSize: 20.0)),
//             onPressed: () {
//               setState(() {
//                 futurePublications = fetchPublications();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:osborn_book/main.dart';
import 'package:osborn_book/pdf/downloaded_pdf_list.dart';
import 'package:osborn_book/widgets/all_books.dart';
import 'package:osborn_book/widgets/book_card.dart';

import 'networking/fetch_response.dart';
import 'networking/publication_model.dart';

import 'package:flutter/material.dart';

import 'networking/fetch_response.dart';
import 'networking/publication_model.dart';
// Ensure this import is correct

class PublicationsScreen extends StatefulWidget {
  final String deviceToken;
  const PublicationsScreen({super.key,required this.deviceToken});
  @override
  _PublicationsScreenState createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  late Future<List<Publication>> futurePublications;

  Future<void> _reloadPublications() async {
    setState(() {
      futurePublications = fetchPublications(widget.deviceToken, context);
    });
  }

  @override
  void initState() {
    super.initState();
    futurePublications = fetchPublications(widget.deviceToken, context);
    print("inside the init state");
    print(futurePublications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publications'),
      ),
      body: Flex(
        direction: Axis.horizontal,
        children:[ AllBooksWidget(futurePublications: futurePublications, onReload: _reloadPublications,),
    ]
      ),
    );
  }
}
//
// class AllBooksWidget extends StatelessWidget {
//   const AllBooksWidget({
//     super.key,
//     required this.futurePublications,
//   });
//
//   final Future<List<Publication>> futurePublications;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: FutureBuilder<List<Publication>>(
//         future: futurePublications,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (snapshot.hasData) {
//             // Changed ListView.builder to GridView.builder
//             return GridView.builder(
//               gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // Number of columns
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//               ),
//               itemCount: snapshot.data?.length ?? 0,
//               itemBuilder: (context, index) {
//                 final publication = snapshot.data![index];
//                 // Use BookCard instead of ListTile
//                 return BookCard(
//                   title: publication.title,
//                   imagePath: publication.coverUrl,
//                   url: publication.pathUrl,// Changed to use coverUrl for imagePath
//                   urlToPdf: publication.pathUrl,
//                 );
//               },
//             );
//           }
//           return Center(child: Text("No data available"));
//         },
//       ),
//     );
//   }
// }
//
// // You would need a WebViewScreen to handle navigation if you want to open the URL
//

//
// class AllBooksWidget extends StatefulWidget {
//   const AllBooksWidget({
//     super.key,
//     required this.futurePublications, required this.onReload,
//   });
//
//   final Future<List<Publication>> futurePublications;
//   final VoidCallback onReload;
//
//   @override
//   State<AllBooksWidget> createState() => _AllBooksWidgetState();
// }
//
// class _AllBooksWidgetState extends State<AllBooksWidget> {
//
//   Widget noInternetDialog(BuildContext context) {
//     return AlertDialog(
//       title: Text("No Internet Connection"),
//       content: Text("Please check your internet connection and try again."),
//       actions: <Widget>[
//         TextButton(
//           child: Text("Go to Download"),
//           onPressed: ()  {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DownloadedPdfsPage()),
//             );
//           },
//         ),
//         TextButton(
//           child: Text("Reload"),
//           onPressed: () {
//             Navigator.pop(context);
//             widget.onReload();
//             // Close the dialog first
//              // Call the onReload function to fetch data again
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Publication>>(
//       future: widget.futurePublications,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         } else if (snapshot.hasData) {
//           // Changed ListView.builder to GridView.builder
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, // Number of columns
//               crossAxisSpacing: 8.0,
//               mainAxisSpacing: 8.0,
//             ),
//             itemCount: snapshot.data?.length ?? 0,
//             itemBuilder: (context, index) {
//               final publication = snapshot.data![index];
//               // Use BookCard instead of ListTile
//               return BookCard(
//                 title: publication.title,
//                 imagePath: publication.coverUrl,
//                 url: publication.pathUrl,
//                 urlToPdf: publication.urlToPdf,
//               );
//             },
//           );
//         }
//         return Center(child: Text("No data available"));
//       },
//     );
//   }
// }
