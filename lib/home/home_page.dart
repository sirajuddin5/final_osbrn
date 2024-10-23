// // // import 'package:flutter/material.dart';
// // //
// // // class HomePage extends StatefulWidget {
// // //   final String deviceToken;
// // //   const HomePage({super.key,  required this.deviceToken});
// // //
// // //   @override
// // //   State<HomePage> createState() => _HomePgeState();
// // // }
// // //
// // // class _HomePgeState extends State<HomePage> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       home: Scaffold(
// // //         appBar: AppBar(
// // //           title: const Text(
// // //             "All Books",
// // //             style: TextStyle(color: Colors.white),
// // //           ),
// // //           // leading: IconButton(
// // //           //   onPressed: () {
// // //           //     //   TODO
// // //           //   },
// // //           //   icon: const Icon(
// // //           //     Icons.menu,
// // //           //     color: Colors.white,
// // //           //   ),
// // //           // ),
// // //
// // //           backgroundColor: Colors.deepPurple,
// // //         ),
// // //         drawer: Drawer(
// // //           child: ListView(
// // //             padding: EdgeInsets.zero,
// // //             children: <Widget>[
// // //               DrawerHeader(
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.deepPurple, // Background color for the header
// // //                 ),
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     // Replace with your logo or image
// // //                     Image.asset(
// // //                       'images/onboarding.png',
// // //                       height: 50,
// // //                       width: 50,
// // //                     ),
// // //                     SizedBox(height: 10),
// // //                     Text(
// // //                       'osborne BOOKS',
// // //                       style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 24,
// // //                       ),
// // //                     ),
// // //                     Text(
// // //                       'Lifeline for Learning',
// // //                       style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 14,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               ListTile(
// // //                 leading: Icon(Icons.book),
// // //                 title: Text('All Books'),
// // //                 onTap: () {
// // //                   // Navigate to the All Books page
// // //                 },
// // //               ),
// // //               ListTile(
// // //                 leading: Icon(Icons.save_alt),
// // //                 title: Text('On Device'),
// // //                 onTap: () {
// // //                   // Navigate to the On Device page
// // //                 },
// // //               ),
// // //               Divider(),
// // //               ListTile(
// // //                 leading: Icon(Icons.exit_to_app),
// // //                 title: Text('Sign Out'),
// // //                 subtitle: Text('books@osbornebooks.co.uk'),
// // //                 onTap: () {
// // //                   // Sign out logic
// // //                 },
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// //
// // class HomePage extends StatefulWidget {
// //   final String deviceToken;
// //   const HomePage({super.key, required this.deviceToken});
// //
// //   @override
// //   State<HomePage> createState() => _HomePgeState();
// // }
// //
// // class _HomePgeState extends State<HomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text(
// //             "All Books",
// //             style: TextStyle(color: Colors.white),
// //           ),
// //           leading: Builder(
// //             builder: (BuildContext context) {
// //               return IconButton(
// //                 icon: const Icon(
// //                   Icons.menu,
// //                   color: Colors.white, // Set the icon color to white
// //                 ),
// //                 onPressed: () {
// //                   Scaffold.of(context).openDrawer(); // Open the drawer
// //                 },
// //               );
// //             },
// //           ),
// //           backgroundColor: Colors.deepPurple,
// //         ),
// //         drawer: Drawer(
// //           child: ListView(
// //             padding: EdgeInsets.zero,
// //             children: <Widget>[
// //               DrawerHeader(
// //                 decoration: BoxDecoration(
// //                   color: Colors.deepPurple, // Background color for the header
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Replace with your logo or image
// //                     Image.asset(
// //                       'images/onboarding.png',
// //                       height: 50,
// //                       width: 50,
// //                     ),
// //                     SizedBox(height: 10),
// //                     Text(
// //                       'osborne BOOKS',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 24,
// //                       ),
// //                     ),
// //                     Text(
// //                       'Lifeline for Learning',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               ListTile(
// //                 leading: Icon(Icons.book),
// //                 title: Text('All Books'),
// //                 onTap: () {
// //                   // Navigate to the All Books page
// //                 },
// //               ),
// //               ListTile(
// //                 leading: Icon(Icons.save_alt),
// //                 title: Text('On Device'),
// //                 onTap: () {
// //                   // Navigate to the On Device page
// //                 },
// //               ),
// //               Divider(),
// //               ListTile(
// //                 leading: Icon(Icons.exit_to_app),
// //                 title: Text('Sign Out'),
// //                 subtitle: Text('books@osbornebooks.co.uk'),
// //                 onTap: () {
// //                   // Sign out logic
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //
// //
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
//
// import '../widgets/book_card.dart';
//
// class HomePage extends StatefulWidget {
//   final String deviceToken;
//   const HomePage({super.key, required this.deviceToken});
//
//   @override
//   State<HomePage> createState() => _HomePgeState();
// }
//
// class _HomePgeState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     // Sample list of books
//     final List<Map<String, String>> books = [
//       {"title": "Book One", "imagePath": "images/book1.png"},
//       {"title": "Book Two", "imagePath": "images/book2.png"},
//       {"title": "Book Three", "imagePath": "images/book3.png"},
//       {"title": "Book Four", "imagePath": "images/book4.png"},
//       {"title": "Book Five", "imagePath": "images/book5.png"},
//       {"title": "Book Six", "imagePath": "images/book6.png"},
//     ];
//
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "All Books",
//             style: TextStyle(color: Colors.white),
//           ),
//           leading: Builder(
//             builder: (BuildContext context) {
//               return IconButton(
//                 icon: const Icon(
//                   Icons.menu,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer(); // Open the drawer
//                 },
//               );
//             },
//           ),
//           backgroundColor: Colors.deepPurple,
//         ),
//         drawer: CustomDrawer(),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, // Number of columns
//               crossAxisSpacing: 10, // Space between columns
//               mainAxisSpacing: 10, // Space between rows
//               childAspectRatio: 2 / 3, // Aspect ratio for each card
//             ),
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               return BookCard(
//                 title: books[index]['title']!,
//                 imagePath: books[index]['imagePath']!,
//                 url: books[index]['path_url']!,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.deepPurple,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.asset(
//                   'images/onboarding.png',
//                   height: 50,
//                   width: 50,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'osborne BOOKS',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                 ),
//                 Text(
//                   'Lifeline for Learning',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.book),
//             title: Text('All Books'),
//             onTap: () {
//               // Navigate to the All Books page
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.save_alt),
//             title: Text('On Device'),
//             onTap: () {
//               // Navigate to the On Device page
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.exit_to_app),
//             title: Text('Sign Out'),
//             subtitle: Text('books@osbornebooks.co.uk'),
//             onTap: () {
//               // Sign out logic
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../networking/fetch_response.dart';
import '../networking/publication_model.dart';
import '../publication_screen.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  final String deviceToken;
  const HomePage({super.key, required this.deviceToken});

  @override
  State<HomePage> createState() => _HomePgeState();
}

class _HomePgeState extends State<HomePage> {
  late Future<List<Publication>>? futurePublications;


  @override
  void initState() {
    super.initState();
    print(widget.deviceToken);
    futurePublications = fetchPublications(widget.deviceToken);
    // print(futurePublications);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "All Books",
            style: TextStyle(color: Colors.white),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              );
            },
          ),
          backgroundColor: Colors.deepPurple,
        ),
        drawer: CustomDrawer(),

        body:AllBooksWidget(futurePublications:  fetchPublications(widget.deviceToken),),
      ),
    );
  }
}


