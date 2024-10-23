// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// import 'downloaded_pdf_list.dart';
//
// class PdfViewerPage extends StatefulWidget {
//   final String title;
//   final String imagePath;
//   final String url;
//   final String? urlToPdf;
//
//   const PdfViewerPage({ required this.title, required this.imagePath, required this.url,required this.urlToPdf});
//   @override
//   _PdfViewerPageState createState() => _PdfViewerPageState();
// }
//
// class _PdfViewerPageState extends State<PdfViewerPage> {
//   String pdfPath = ''; // Store the local path of the cached PDF.
//   bool isLoading = true;
//   double downloadProgress = 0.0; // Variable to track the download progress.
//   bool isDownloaded = false; // Track if the file is downloaded to app storage
//   ScaffoldMessengerState? scaffoldMessenger; // To control snackbar
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAndCachePdf();
//   }
//
//   // Function to download and cache the PDF file.
//   Future<void> fetchAndCachePdf() async {
//     try {
//       WidgetsFlutterBinding.ensureInitialized();
//       Directory cacheDir = await getTemporaryDirectory();
//       String filePath = '${cacheDir.path}/${widget.title}.pdf';
//
//       // Check if the file already exists in the cache.
//       if (File(filePath).existsSync()) {
//         setState(() {
//           pdfPath = filePath;
//           isLoading = false;
//         });
//       } else {
//         Dio dio = Dio();
//         String url = widget.urlToPdf.toString();
//
//         await dio.download(
//           url,
//           filePath,
//           onReceiveProgress: (receivedBytes, totalBytes) {
//             if (totalBytes != -1) {
//               setState(() {
//                 downloadProgress = (receivedBytes / totalBytes) * 100;
//               });
//             }
//           },
//         );
//
//         setState(() {
//           pdfPath = filePath;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       showErrorDialog(e.toString());
//     }
//   }
//
//   // Function to save the cached PDF to the application's document directory.
//   Future<void> savePdfToDocuments() async {
//     try {
//       Directory appDocDir = await getApplicationDocumentsDirectory();
//       String appFilePath = '${appDocDir.path}/${widget.title}.pdf';
//
//       // Copy the cached PDF file to the application's document directory.
//       File cachedPdf = File(pdfPath);
//       await cachedPdf.copy(appFilePath);
//
//       scaffoldMessenger?.showSnackBar(
//         SnackBar(
//           content: Text('PDF downloaded to app\'s storage!'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//
//       setState(() {
//         isDownloaded = true;
//       });
//     } catch (e) {
//       showErrorDialog(e.toString());
//     }
//   }
//
//   // Show error dialog in case of failure.
//   void showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     if (pdfPath.isNotEmpty) {
//       final file = File(pdfPath);
//       if (file.existsSync()) {
//         file.deleteSync();
//         print('Cached PDF file deleted.');
//       }
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     scaffoldMessenger = ScaffoldMessenger.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () async {
//               if (pdfPath.isNotEmpty) {
//                 await savePdfToDocuments();
//               }
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.list), // Button to navigate to downloaded PDFs
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DownloadedPdfsPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Downloading: ${downloadProgress.toStringAsFixed(0)}%',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             CircularProgressIndicator(value: downloadProgress / 100),
//           ],
//         ),
//       )
//           : SfPdfViewer.file(File(pdfPath)),
//     );
//   }
// }
//
