// // //
// // //
// // // import 'dart:io';
// // // import 'package:dio/dio.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:path_provider/path_provider.dart';
// // // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// // //
// // // class PdfViewerPage extends StatefulWidget {
// // //   @override
// // //   _PdfViewerPageState createState() => _PdfViewerPageState();
// // // }
// // //
// // // class _PdfViewerPageState extends State<PdfViewerPage> {
// // //   String pdfPath = ''; // Store the local path of the cached PDF.
// // //   bool isLoading = true;
// // //   double downloadProgress = 0.0; // Variable to track the download progress.
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchAndCachePdf();
// // //   }
// // //
// // //   // Function to download and cache the PDF file.
// // //   Future<void> fetchAndCachePdf() async {
// // //     try {
// // //       // Ensure the platform is ready before fetching the directory.
// // //       WidgetsFlutterBinding.ensureInitialized();
// // //
// // //       // Get the directory to store the cached PDF.
// // //       Directory cacheDir = await getTemporaryDirectory();
// // //       String filePath = '${cacheDir.path}/CSFT_Workbook.pdf';
// // //
// // //       // Check if the file already exists in the cache.
// // //       if (File(filePath).existsSync()) {
// // //         setState(() {
// // //           pdfPath = filePath;
// // //           isLoading = false;
// // //         });
// // //       } else {
// // //         // Download the PDF using Dio.
// // //         Dio dio = Dio();
// // //         String url = 'https://www.osbornebooks.co.uk/storage/pdf/CRDM_Wkbk_press_file.pdf';
// // //
// // //         await dio.download(
// // //           url,
// // //           filePath,
// // //           onReceiveProgress: (receivedBytes, totalBytes) {
// // //             // Calculate download progress percentage.
// // //             if (totalBytes != -1) {
// // //               setState(() {
// // //                 downloadProgress = (receivedBytes / totalBytes) * 100;
// // //               });
// // //             }
// // //           },
// // //         );
// // //
// // //         setState(() {
// // //           pdfPath = filePath;
// // //           isLoading = false;
// // //         });
// // //       }
// // //     } catch (e) {
// // //       setState(() {
// // //         isLoading = false;
// // //       });
// // //       showErrorDialog(e.toString());
// // //     }
// // //   }
// // //
// // //   // Show error dialog in case of failure.
// // //   void showErrorDialog(String message) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: Text('Error'),
// // //         content: Text(message),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.of(context).pop(),
// // //             child: Text('OK'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('PDF Viewer'),
// // //       ),
// // //       body: isLoading
// // //           ? Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Text(
// // //               'Downloading: ${downloadProgress.toStringAsFixed(0)}%',
// // //               style: TextStyle(fontSize: 18),
// // //             ),
// // //             SizedBox(height: 20),
// // //             LinearProgressIndicator(value: downloadProgress / 100),
// // //           ],
// // //         ),
// // //       )
// // //           : SfPdfViewer.file(File(pdfPath)),
// // //     );
// // //   }
// // // }
// //
// //
// //
// //
// // import 'dart:io';
// // import 'package:dio/dio.dart';
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// //
// // import 'downloaded_pdf_list.dart';
// //
// // class PdfViewerPage extends StatefulWidget {
// //   final String title;
// //   final String imagePath;
// //   final String url;
// //   final String? urlToPdf;
// //
// //   const PdfViewerPage({ required this.title, required this.imagePath, required this.url,required this.urlToPdf});
// //   @override
// //   _PdfViewerPageState createState() => _PdfViewerPageState();
// // }
// //
// // class _PdfViewerPageState extends State<PdfViewerPage> {
// //   String pdfPath = ''; // Store the local path of the cached PDF.
// //   bool isLoading = true;
// //   double downloadProgress = 0.0; // Variable to track the download progress.
// //   bool isDownloaded = false; // Track if the file is downloaded to app storage
// //   ScaffoldMessengerState? scaffoldMessenger; // To control snackbar
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchAndCachePdf();
// //   }
// //
// //   // Function to download and cache the PDF file.
// //   Future<void> fetchAndCachePdf() async {
// //     try {
// //       WidgetsFlutterBinding.ensureInitialized();
// //       Directory cacheDir = await getTemporaryDirectory();
// //       String filePath = '${cacheDir.path}/${widget.title}.pdf';
// //
// //       // Check if the file already exists in the cache.
// //       if (File(filePath).existsSync()) {
// //         setState(() {
// //           pdfPath = filePath;
// //           isLoading = false;
// //         });
// //       } else {
// //         Dio dio = Dio();
// //         String url = widget.urlToPdf.toString();
// //
// //         await dio.download(
// //           url,
// //           filePath,
// //           onReceiveProgress: (receivedBytes, totalBytes) {
// //             if (totalBytes != -1) {
// //               setState(() {
// //                 downloadProgress = (receivedBytes / totalBytes) * 100;
// //               });
// //             }
// //           },
// //         );
// //
// //         setState(() {
// //           pdfPath = filePath;
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       showErrorDialog(e.toString());
// //     }
// //   }
// //
// //   // Function to save the cached PDF to the application's document directory.
// //   Future<void> savePdfToDocuments() async {
// //     try {
// //       Directory appDocDir = await getApplicationDocumentsDirectory();
// //       String appFilePath = '${appDocDir.path}/${widget.title}.pdf';
// //
// //       // Copy the cached PDF file to the application's document directory.
// //       File cachedPdf = File(pdfPath);
// //       await cachedPdf.copy(appFilePath);
// //
// //       scaffoldMessenger?.showSnackBar(
// //         SnackBar(
// //           content: Text('PDF downloaded to app\'s storage!'),
// //           duration: Duration(seconds: 2),
// //         ),
// //       );
// //
// //       setState(() {
// //         isDownloaded = true;
// //       });
// //     } catch (e) {
// //       showErrorDialog(e.toString());
// //     }
// //   }
// //
// //   // Show error dialog in case of failure.
// //   void showErrorDialog(String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Error'),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(),
// //             child: Text('OK'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     if (pdfPath.isNotEmpty) {
// //       final file = File(pdfPath);
// //       if (file.existsSync()) {
// //         file.deleteSync();
// //         print('Cached PDF file deleted.');
// //       }
// //     }
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     scaffoldMessenger = ScaffoldMessenger.of(context);
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('PDF Viewer'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.download),
// //             onPressed: () async {
// //               if (pdfPath.isNotEmpty) {
// //                 await savePdfToDocuments();
// //               }
// //             },
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.list), // Button to navigate to downloaded PDFs
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => DownloadedPdfsPage()),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //       body: isLoading
// //           ? Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(
// //               'Downloading: ${downloadProgress.toStringAsFixed(0)}%',
// //               style: TextStyle(fontSize: 18),
// //             ),
// //             SizedBox(height: 20),
// //             CircularProgressIndicator(value: downloadProgress / 100),
// //           ],
// //         ),
// //       )
// //           : SfPdfViewer.file(File(pdfPath)),
// //     );
// //   }
// // }
// //
// //
//

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/search_toolbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'app_state.dart';
import 'bookmark.dart';
import 'bookmark_page.dart';
import 'downloaded_pdf_list.dart';
import 'grid_page.dart';
import 'highlights_page.dart';
import 'notes_page.dart';

class PdfViewerPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String url;
  final String urlToPdf;

  const PdfViewerPage({
    required this.title,
    required this.imagePath,
    required this.url,
    required this.urlToPdf,
  });

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String pdfPath = ''; // Store the local path of the cached PDF.
  bool isLoading = true;
  double downloadProgress = 0.0; // Variable to track the download progress.
  bool isDownloaded = false; // Track if the file is downloaded to app storage
  bool showDialogOnce = false; // Prevent multiple dialog calls

  //// copied code
  int _selectedIndex = 0;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  PdfTextSelectionChangedDetails? _selectionDetails;
  late bool _showToolbar;
  late bool _showScrollHead;
  LocalHistoryEntry? _historyEntry;

  // Initialize SQLite DB
  Future<void> _initializeDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "app_data.db";
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE Highlights (id INTEGER PRIMARY KEY, pageNumber INTEGER, text TEXT)");
        await db.execute(
            "CREATE TABLE Notes (id INTEGER PRIMARY KEY, pageNumber INTEGER, text TEXT, note TEXT, x REAL, y REAL, color INTEGER)");
        await db.execute(
            "CREATE TABLE BookMarks (id TEXT PRIMARY KEY, pageNumber INTEGER)");
        await db.execute(
            "CREATE TABLE Mark (id INTEGER PRIMARY KEY, pageNumber INTEGER, x REAL, y REAL)");
      },
    );
    Provider.of<AppState>(context, listen: false).setDatabase(database);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  void _handleHistoryEntryRemoved() {
    _textSearchKey.currentState?.clearSearch();
    setState(() {
      _showToolbar = false;
    });
    _historyEntry = null;
  }

  void _showBookmarks() async {
    final selectedPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookmarksPage()),
    );
    if (selectedPage != null) {
      _pdfViewerController.jumpToPage(selectedPage);
    }
  }

  late List<int> myanno;

  // HIGLIGHT
  Widget _buildPdfViewer() {
    return Stack(children: [
      Column(
        children: [
          Expanded(
            child: SfPdfViewer.file(
              File(pdfPath),
              controller: _pdfViewerController,
              key: _pdfViewerKey,
              pageLayoutMode: PdfPageLayoutMode.single,

              onAnnotationAdded: (Annotation annotation) {
                print(annotation);
                // print("hellojyghnyhy ${_pdfViewerController.exportFormData(dataFormat: DataFormat.xfdf )}");
                Provider.of<AppState>(context, listen: false)
                    .addHighlight(
                  _pdfViewerController.pageNumber,
                  Provider.of<AppState>(context, listen: false).raam,
                );

              },
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                print("fjowejfowijfoqjfo ${_pdfViewerKey.currentState?.getSelectedTextLines()}");
                final annotations = details.globalSelectedRegion;
                print(annotations);
                if (details.selectedText != null && details.selectedText!.isNotEmpty) {
                  setState(() {
                    _selectionDetails = details;
                    Provider.of<AppState>(context, listen: false)
                        .updateData(_selectionDetails!.selectedText as String);

                  });

                }
              },
            ),
          ),


          // REMOVE HIGLIGHT



          Visibility(
            visible: _textSearchKey.currentState?.showToast ?? false,
            child: Align(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding:
                    EdgeInsets.only(left: 15, top: 7, right: 15, bottom: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      'No result',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectionDetails != null &&
              _selectionDetails!.selectedText != null)
            Container(
              color: Colors.grey[200],
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.highlight),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false)
                          .addHighlight(
                        _pdfViewerController.pageNumber!,
                        _selectionDetails!.selectedText!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Text highlighted!")));
                      _selectionDetails = null;
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.note_add),
                    onPressed: () {
                      _addNoteDialog(_pdfViewerController.pageNumber!,
                          _selectionDetails!.selectedText!);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ]);
  }

  void _showHighlights() async {
    final selectedPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HighlightsPage()),
    );
    if (selectedPage != null) {
      _pdfViewerController.jumpToPage(selectedPage);
    }
  }

  void _showNotes() async {
    final selectedPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotesPage()),
    );
    if (selectedPage != null) {
      _pdfViewerController.jumpToPage(selectedPage);
    }
  }

  void _addNoteDialog(int pageNumber, String selectedText) {
    TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add a Note"),
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(hintText: "Enter your note here"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Provider.of<AppState>(context, listen: false).addNote(
                pageNumber,
                selectedText,
                noteController.text,
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Note added!")));
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addHighlight() {
    if (_selectionDetails != null && _selectionDetails!.selectedText != null) {
      final pageNumber = _pdfViewerController.pageNumber!;
      final selectedText = _selectionDetails!.selectedText!;

      // // Add visual highlight
      // _pdfViewerController.addHighlight(_selectionDetails!);

      // Save highlight to AppState
      Provider.of<AppState>(context, listen: false).addHighlight(
        pageNumber,
        selectedText,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text highlighted')),
      );

      // Clear selection
      setState(() {
        _selectionDetails = null;
      });
    }
  }

  ///////////////////

  @override
  void initState() {
    _showToolbar = false;
    _showScrollHead = true;
    super.initState();
    _initializeDb();
    if (widget.urlToPdf.isEmpty) {
      setState(() {
        isLoading = false; // Set loading to false to show the image
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoPdfAvailableDialog(); // Show dialog after the frame is built
      });
    } else {
      fetchAndCachePdf();
    }
  }

  // Function to download and cache the PDF file.
  Future<void> fetchAndCachePdf() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      Directory cacheDir = await getTemporaryDirectory();
      String filePath = '${cacheDir.path}/${widget.title}.pdf';

      // Check if the file already exists in the cache.
      if (File(filePath).existsSync()) {
        setState(() {
          pdfPath = filePath;
          isLoading = false;
        });
      } else {
        Dio dio = Dio();
        String url = widget.urlToPdf; // Use the non-null url

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (receivedBytes, totalBytes) {
            if (totalBytes != -1) {
              setState(() {
                downloadProgress = (receivedBytes / totalBytes) * 100;
              });
            }
          },
        );

        setState(() {
          pdfPath = filePath;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(e.toString());
    }
  }

  // Function to show a dialog when no PDF is available
  void _showNoPdfAvailableDialog() {
    if (!showDialogOnce) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No PDF Available'),
          content: Text('Currently, no PDF is available for this document.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      showDialogOnce = true; // Ensure dialog is shown only once
    }
  }

  // Function to save the cached PDF to the application's document directory.
  Future<void> savePdfToDocuments() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appFilePath = '${appDocDir.path}/${widget.title}.pdf';

      // Copy the cached PDF file to the application's document directory.
      File cachedPdf = File(pdfPath);
      await cachedPdf.copy(appFilePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded to app\'s storage!'),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        isDownloaded = true;
      });
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  // Show error dialog in case of failure.
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   if (pdfPath.isNotEmpty) {
  //     final file = File(pdfPath);
  //     if (file.existsSync()) {
  //       file.deleteSync();
  //       print('Cached PDF file deleted.');
  //     }
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showToolbar ?
          AppBar(
            flexibleSpace: SafeArea(
                child: SearchToolbar(
                  key: _textSearchKey,
                  showTooltip: true,
                  controller: _pdfViewerController,
                  onTap: (Object toolbarItem) async {
                    if(toolbarItem.toString() == 'Cancel Search'){
                      setState(() {
                        _showToolbar = false;
                        _showScrollHead = true;
                        if(Navigator.canPop(context)){
                          Navigator.maybePop(context);
                        }
                      });
                    }
                    if(toolbarItem.toString() =='noResultFound'){
                      setState(() {
                        _textSearchKey.currentState?.showToast = true;
                      });
                      await Future.delayed(Duration(seconds: 1));
                      setState(() {
                        _textSearchKey.currentState?.showToast = false;
                      });
                    }
                  },
                ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.deepPurple,
          )
      : AppBar(
        title:const Text(
          "Osborne",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showScrollHead = false;
                _showToolbar = true;
                _ensureHistoryEntry();
              });
            },
          ),
          IconButton(
              onPressed: _showBookmarks,
              icon: Icon(Icons.bookmark, color: Colors.white)),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
      ),

      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading: ${downloadProgress.toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(value: downloadProgress / 100),
          ],
        ),
      )
          : widget.urlToPdf.isEmpty
          ? Center(child: Image.network(widget.imagePath)) // Display the image if no PDF
          : Column(
        children: [
          Expanded(child: _buildPdfViewer()),
          Container(
            color: Colors.deepPurple,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.list,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    _pdfViewerKey.currentState?.openBookmarkView();
                  },
                ),
                IconButton(
                  // Add this new IconButton for the grid view
                  icon: Icon(Icons.grid_view,
                      color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfGridView(
                          pdfViewerController: _pdfViewerController,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.highlight_rounded,
                    color: Colors.white,
                  ),
                  onPressed: _showHighlights,
                ),
                IconButton(
                  icon: Icon(
                    Icons.note,
                    color: Colors.white,
                  ),
                  onPressed: _showNotes,
                ),
                IconButton(
                  icon: Icon(
                    Icons.bookmark_add,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    final currentPage = _pdfViewerController.pageNumber;
                    final bookmark = Bookmark(
                      id: 'page_$currentPage',
                      pageNumber: currentPage,
                    );

                    Provider.of<AppState>(context, listen: false)
                        .addBookmark(bookmark)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Page $currentPage bookmarked')),
                      );
                    });
                  },
                ),

                IconButton(


                  icon:const Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (pdfPath.isNotEmpty) {
                       await savePdfToDocuments();
                        }
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}
