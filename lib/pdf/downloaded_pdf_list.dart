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
import 'package:osborn_book/pdf/models/downloaded_pdf.dart';
import 'package:osborn_book/pdf/service/download_service.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
import 'downloaded_pdf_viewer.dart';

class DownloadedPdfsPage extends StatefulWidget {
  const DownloadedPdfsPage({Key? key}) : super(key: key);

  @override
  State<DownloadedPdfsPage> createState() => _DownloadedPdfsPageState();
}

class _DownloadedPdfsPageState extends State<DownloadedPdfsPage> {
  @override
  void initState() {
    super.initState();
    // Validate that all saved PDFs actually exist in the file system
    HiveService.validatePdfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloaded PDFs'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<DownloadedPdf>>(
        future: _getDownloadedPdfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No downloaded PDFs found.'));
          }

          // List of downloaded PDFs
          List<DownloadedPdf> pdfs = snapshot.data!;

          // Use GridView like in AllBooksWidget
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75,
            ),
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              return _buildPdfCard(pdf);
            },
          );
        },
      ),
    );
  }

  Widget _buildPdfCard(DownloadedPdf pdf) {
    String displayTitle = pdf.title;
    if (displayTitle.length > 25) {
      displayTitle = displayTitle.substring(0, 22) + '...';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DownloadedPdfViewerPage(
              pdfData: pdf,
            ),
          ),
        ).then((_) {
          // Refresh the list when returning from the PDF viewer
          setState(() {});
        });
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover image or placeholder
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                child: pdf.coverImagePath.isNotEmpty
                    ? Image.file(
                        File(pdf.coverImagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.picture_as_pdf, size: 50),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.picture_as_pdf, size: 50),
                      ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Downloaded date
                      Text(
                        _formatDate(pdf.downloadDate),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      // Delete button
                      InkWell(
                        onTap: () => _deletePdf(pdf),
                        child: const Icon(
                          Icons.delete,
                          size: 20.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get downloaded PDFs from Hive
  Future<List<DownloadedPdf>> _getDownloadedPdfs() async {
    return HiveService.getAllPdfs();
  }

  // Delete PDF file and entry from Hive
  void _deletePdf(DownloadedPdf pdf) async {
    final bool confirm = await _showDeleteConfirmationDialog(context);
    if (confirm) {
      try {
        // Check if file exists before trying to delete it
        final file = File(pdf.localPath);
        if (await file.exists()) {
          await file.delete();
        }

        // If cover image exists, delete it too
        if (pdf.coverImagePath.isNotEmpty) {
          final coverFile = File(pdf.coverImagePath);
          if (await coverFile.exists()) {
            await coverFile.delete();
          }
        }

        // Remove from Hive database
        await HiveService.deletePdf(pdf.urlId);

        // Refresh the list
        setState(() {});
      } catch (e) {
        print('Error deleting PDF: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete PDF')),
        );
      }
    }
  }

  // Function to show delete confirmation dialog
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete PDF'),
          content: const Text(
              'Are you sure you want to delete this PDF and all its annotations?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false; // Return false if dialog is dismissed
  }
}
