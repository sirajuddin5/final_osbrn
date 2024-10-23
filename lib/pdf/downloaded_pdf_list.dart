// //
// //
// //
// // import 'dart:io';
// //
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// //
// // import 'downloaded_pdf_viewer.dart';
// //
// // class DownloadedPdfsPage extends StatefulWidget {
// //   @override
// //   State<DownloadedPdfsPage> createState() => _DownloadedPdfsPageState();
// // }
// //
// // class _DownloadedPdfsPageState extends State<DownloadedPdfsPage> {
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Downloaded PDFs'),
// //         backgroundColor: Colors.deepPurple,
// //       ),
// //       body: FutureBuilder<List<FileSystemEntity>>(
// //         future: _getDownloadedPdfs(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (snapshot.data!.isEmpty) {
// //             return Center(child: Text('No downloaded PDFs found.'));
// //           }
// //
// //           // List of downloaded PDFs
// //           List<FileSystemEntity> files = snapshot.data!;
// //
// //           return ListView.builder(
// //             itemCount: files.length,
// //             itemBuilder: (context, index) {
// //               final file = files[index];
// //               return ListTile(
// //                 title: Text(file.path.split('/').last), // Extract file name
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => MainPage(path: file.path, title: file.path.split('/').last,),
// //                     ),
// //                   );
// //                 },
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   // Function to retrieve downloaded PDF files
// //   Future<List<FileSystemEntity>> _getDownloadedPdfs() async {
// //     Directory appDocDir = await getApplicationDocumentsDirectory();
// //     return Directory(appDocDir.path).listSync()
// //         .where((entity) => entity.path.endsWith('.pdf')).toList();
// //   }
// // }
//
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'downloaded_pdf_viewer.dart';
//
// class DownloadedPdfsPage extends StatefulWidget {
//   @override
//   State<DownloadedPdfsPage> createState() => _DownloadedPdfsPageState();
// }
//
// class _DownloadedPdfsPageState extends State<DownloadedPdfsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Downloaded PDFs'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: FutureBuilder<List<FileSystemEntity>>(
//         future: _getDownloadedPdfs(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return Center(child: Text('No downloaded PDFs found.'));
//           }
//
//           // List of downloaded PDFs
//           List<FileSystemEntity> files = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: files.length,
//             itemBuilder: (context, index) {
//               final file = files[index];
//               return ListTile(
//                 title: Text(file.path.split('/').last), // Extract file name
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => MainPage(
//                         path: file.path,
//                         title: file.path.split('/').last,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // Function to retrieve downloaded PDF files
//   Future<List<FileSystemEntity>> _getDownloadedPdfs() async {
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     return Directory(appDocDir.path)
//         .listSync()
//         .where((entity) => entity.path.endsWith('.pdf'))
//         .toList();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'downloaded_pdf_viewer.dart';

class DownloadedPdfsPage extends StatefulWidget {
  @override
  State<DownloadedPdfsPage> createState() => _DownloadedPdfsPageState();
}

class _DownloadedPdfsPageState extends State<DownloadedPdfsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded PDFs'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _getDownloadedPdfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No downloaded PDFs found.'));
          }

          // List of downloaded PDFs
          List<FileSystemEntity> files = snapshot.data!;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return ListTile(
                title: Text(file.path.split('/').last), // Extract file name
                trailing: IconButton(
                  icon: Icon(Icons.delete, ),
                  onPressed: () async {
                    // Show confirmation dialog before deletion
                    bool confirm = await _showDeleteConfirmationDialog(context);
                    if (confirm) {
                      // Delete the file
                      await file.delete();
                      setState(() {}); // Refresh the list
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(
                        path: file.path,
                        title: file.path.split('/').last,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Function to retrieve downloaded PDF files
  Future<List<FileSystemEntity>> _getDownloadedPdfs() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return Directory(appDocDir.path)
        .listSync()
        .where((entity) => entity.path.endsWith('.pdf'))
        .toList();
  }

  // Function to show delete confirmation dialog
  // Function to show delete confirmation dialog
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete PDF'),
          content: Text('Are you sure you want to delete this PDF?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false; // Return false if dialog is dismissed
  }

}
