import 'dart:io';

import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/search_toolbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../HighLightsPage.dart';
import 'app_state.dart';
import 'bookmark.dart';
import 'bookmark_page.dart';
import 'grid_page.dart';
import 'highlight_model.dart';
import 'notes_page.dart';
import 'dart:math' show max;

class MainPage extends StatefulWidget {
  final String path;
  final String title;
  const MainPage({super.key, required this.path, required this.title});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  PdfTextSelectionChangedDetails? _selectionDetails;
  late bool _showToolbar;
  late bool _showScrollHead;
  LocalHistoryEntry? _historyEntry;

  @override
  void initState() {
    _showToolbar = false;
    _showScrollHead = true;
    super.initState();
    _initializeDb();
  }

  // Initialize SQLite DB
  Future<void> _initializeDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "app_data.db";
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE Highlights (id INTEGER PRIMARY KEY, pageNumber INTEGER, text TEXT, x REAL, y REAL, width REAL, height REAL, color INTEGER)");
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
      MaterialPageRoute(
          builder: (context) =>
              BookmarksPage(pdfController: _pdfViewerController, urldId: "")),
    );
    if (selectedPage != null) {
      _pdfViewerController.jumpToPage(selectedPage);
    }
  }

  late List<int> myanno;

  // HIGLIGHT
  // Widget _buildPdfViewer() {
  //   return Stack(children: [
  //     Column(
  //       children: [
  //         Expanded(
  //           child: SfPdfViewer.file(
  //             File(widget.path),
  //             controller: _pdfViewerController,
  //             key: _pdfViewerKey,
  //             pageLayoutMode: PdfPageLayoutMode.single,
  //
  //             onAnnotationAdded: (Annotation annotation) {
  //               print(annotation);
  //               // print("hellojyghnyhy ${_pdfViewerController.exportFormData(dataFormat: DataFormat.xfdf )}");
  //               Provider.of<AppState>(context, listen: false)
  //                   .addHighlight(
  //                 _pdfViewerController.pageNumber,
  //                 Provider.of<AppState>(context, listen: false).raam,
  //               );
  //
  //             },
  //             onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
  //               print("fjowejfowijfoqjfo ${_pdfViewerKey.currentState?.getSelectedTextLines()}");
  //               final annotations = details.globalSelectedRegion;
  //               print(annotations);
  //               if (details.selectedText != null && details.selectedText!.isNotEmpty) {
  //                 setState(() {
  //                   _selectionDetails = details;
  //                   Provider.of<AppState>(context, listen: false)
  //                       .updateData(_selectionDetails!.selectedText as String);
  //
  //                 });
  //
  //               }
  //             },
  //           ),
  //         ),
  //
  //
  //         // REMOVE HIGLIGHT
  //
  //
  //
  //         Visibility(
  //           visible: _textSearchKey.currentState?.showToast ?? false,
  //           child: Align(
  //             alignment: Alignment.center,
  //             child: Flex(
  //               direction: Axis.horizontal,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Container(
  //                   padding:
  //                   EdgeInsets.only(left: 15, top: 7, right: 15, bottom: 7),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[600],
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(16.0),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     'No result',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         fontFamily: 'Roboto',
  //                         fontSize: 16,
  //                         color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         if (_selectionDetails != null &&
  //             _selectionDetails!.selectedText != null)
  //           Container(
  //             color: Colors.grey[200],
  //             child: Row(
  //               children: [
  //                 IconButton(
  //                   icon: Icon(Icons.highlight),
  //                   onPressed: () {
  //                     Provider.of<AppState>(context, listen: false)
  //                         .addHighlight(
  //                       _pdfViewerController.pageNumber!,
  //                       _selectionDetails!.selectedText!,
  //                     );
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(content: Text("Text highlighted!")));
  //                     _selectionDetails = null;
  //                     setState(() {});
  //                   },
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.note_add),
  //                   onPressed: () {
  //                     _addNoteDialog(_pdfViewerController.pageNumber!,
  //                         _selectionDetails!.selectedText!);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   ]);
  // }

  // Widget _buildPdfViewer() {
  //   return Stack(
  //     children: [
  //       Column(
  //         children: [
  //           Expanded(
  //             child: SfPdfViewer.file(
  //               File(widget.path),
  //               controller: _pdfViewerController,
  //               key: _pdfViewerKey,
  //               pageLayoutMode: PdfPageLayoutMode.single,
  //               onAnnotationAdded: (Annotation annotation) {
  //                 print("Annotation added: $annotation");
  //
  //                 if (annotation.rect != null) {
  //                   final double x = annotation.bounds!.left;
  //                   final double y = annotation.bounds!.top;
  //                   final double width = annotation.bounds!.width;
  //                   final double height = annotation.bounds!.height;
  //                   final int color = annotation.color.value;
  //
  //                   Provider.of<AppState>(context, listen: false).addHighlight(
  //                     _pdfViewerController.pageNumber!,
  //                     Provider.of<AppState>(context, listen: false).raam,
  //                     x, y, width, height, color,
  //                   );
  //                 }
  //               },
  //               onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
  //                 print("Selected text: ${details.selectedText}");
  //                 print("Selected region: ${details.globalSelectedRegion}");
  //
  //                 if (details.selectedText != null && details.selectedText!.isNotEmpty) {
  //                   setState(() {
  //                     _selectionDetails = details;
  //                     Provider.of<AppState>(context, listen: false)
  //                         .updateData(details.selectedText!);
  //                   });
  //                 }
  //               },
  //             ),
  //           ),
  //
  //           // REMOVE HIGHLIGHT
  //           Visibility(
  //             visible: _textSearchKey.currentState?.showToast ?? false,
  //             child: Align(
  //               alignment: Alignment.center,
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[600],
  //                   borderRadius: BorderRadius.circular(16.0),
  //                 ),
  //                 child: const Text(
  //                   'No result',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           // Highlight and Note buttons
  //           if (_selectionDetails != null && _selectionDetails!.selectedText != null)
  //             Container(
  //               color: Colors.grey[200],
  //               padding: EdgeInsets.symmetric(vertical: 5),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   IconButton(
  //                     icon: const Icon(Icons.highlight, color: Colors.amber),
  //                     onPressed: () {
  //                       if (_selectionDetails!.globalSelectedRegion!=null) {
  //                         final Rect? regions = _selectionDetails!.globalSelectedRegion;
  //                         if (regions != null) {
  //                           final double x = regions.left;
  //                           final double y = regions.top;
  //                           final double width = regions.width;
  //                           final double height = regions.height;
  //                           final int color = Colors.yellow.value;
  //
  //                           Provider.of<AppState>(context, listen: false).addHighlight(
  //                             _pdfViewerController.pageNumber!,
  //                             _selectionDetails!.selectedText!,
  //                             x, y, width, height, color,
  //                           );
  //                         }
  //                       }
  //
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(content: Text("Text highlighted!")),
  //                       );
  //                       setState(() => _selectionDetails = null);
  //                     },
  //                   ),
  //                   IconButton(
  //                     icon: const Icon(Icons.note_add, color: Colors.blue),
  //                     onPressed: () {
  //                       _addNoteDialog(
  //                         _pdfViewerController.pageNumber!,
  //                         _selectionDetails!.selectedText!,
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildPdfViewer() {
  //   return Stack(
  //     children: [
  //       Column(
  //         children: [
  //           Expanded(
  //             child: SfPdfViewer.file(
  //               File(widget.path),
  //               controller: _pdfViewerController,
  //               key: _pdfViewerKey,
  //               pageLayoutMode: PdfPageLayoutMode.single,
  //               onAnnotationAdded: (Annotation annotation) {
  //                 print("Annotation added: $annotation");
  //
  //                 final Rect bounds = annotation.bounds; // Use boundingBox instead of uiBounds
  //
  //                 final double x = bounds.left;
  //                 final double y = bounds.top;
  //                 final double width = bounds.width;
  //                 final double height = bounds.height;
  //                 final int color = annotation.color.value;
  //
  //                 Provider.of<AppState>(context, listen: false).addHighlight(
  //                   _pdfViewerController.pageNumber ?? 1, // Ensure non-null page number
  //                   Provider.of<AppState>(context, listen: false).raam,
  //                   x, y, width, height, color,
  //                 );
  //               },
  //               onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
  //                 if (details.selectedText != null && details.selectedText!.isNotEmpty) {
  //                   print("Selected text: ${details.selectedText}");
  //                   print("Selected region: ${details.globalSelectedRegion}");
  //
  //                   setState(() {
  //                     _selectionDetails = details;
  //                     Provider.of<AppState>(context, listen: false)
  //                         .updateData(details.selectedText!);
  //                   });
  //                 } else {
  //                   setState(() {
  //                     _selectionDetails = null; // Reset if no text is selected
  //                   });
  //                 }
  //               },
  //             ),
  //           ),
  //
  //           // REMOVE HIGHLIGHT
  //           Visibility(
  //             visible: _textSearchKey.currentState?.showToast ?? false,
  //             child: Align(
  //               alignment: Alignment.center,
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[600],
  //                   borderRadius: BorderRadius.circular(16.0),
  //                 ),
  //                 child: const Text(
  //                   'No result',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           // Highlight and Note buttons
  //           if (_selectionDetails != null && _selectionDetails!.selectedText != null)
  //             Container(
  //               color: Colors.grey[200],
  //               padding: EdgeInsets.symmetric(vertical: 5),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   IconButton(
  //                     icon: const Icon(Icons.highlight, color: Colors.amber),
  //                     onPressed: () {
  //                       final Rect? region = _selectionDetails!.globalSelectedRegion;
  //                       if (region != null) {
  //                         final double x = region.left;
  //                         final double y = region.top;
  //                         final double width = region.width;
  //                         final double height = region.height;
  //                         final int color = Colors.yellow.value;
  //
  //                         Provider.of<AppState>(context, listen: false).addHighlight(
  //                           _pdfViewerController.pageNumber ?? 1, // Ensure non-null page number
  //                           _selectionDetails!.selectedText!,
  //                           x, y, width, height, color,
  //                         );
  //                       }
  //
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(content: Text("Text highlighted!")),
  //                       );
  //                       setState(() => _selectionDetails = null);
  //                     },
  //                   ),
  //                   IconButton(
  //                     icon: const Icon(Icons.note_add, color: Colors.blue),
  //                     onPressed: () {
  //                       if (_selectionDetails != null && _selectionDetails!.selectedText != null) {
  //                         _addNoteDialog(
  //                           _pdfViewerController.pageNumber ?? 1,
  //                           _selectionDetails!.selectedText!,
  //                         );
  //                       }
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildPdfViewer() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SfPdfViewer.file(
                File(widget.path),
                controller: _pdfViewerController,
                key: _pdfViewerKey,
                pageLayoutMode: PdfPageLayoutMode.single,
                onPageChanged: (PdfPageChangedDetails details) {
                  print("[PDF] Page changed to: ${details.newPageNumber}");

                  // Clear existing highlights and load new ones
                  _clearHighlightOverlays();
                  _loadPageHighlights(details.newPageNumber);
                },
                onZoomLevelChanged: (PdfZoomDetails details) {
                  print("[PDF] Zoom changed to: ${details.newZoomLevel}");

                  // Reload highlights for current page with new zoom level
                  final int currentPage = _pdfViewerController.pageNumber ?? 1;
                  _clearHighlightOverlays();
                  _loadPageHighlights(currentPage);
                },
                onAnnotationAdded: (Annotation annotation) {
                  print("Annotation added: $annotation");

                  // If available, get the annotation details from _selectionDetails
                  if (_selectionDetails != null) {
                    final Rect? region =
                        _selectionDetails!.globalSelectedRegion;
                    // final Rect region = details.bounds!.first;

                    if (region != null) {
                      final double x = region.left;
                      final double y = region.top;
                      final double width = region.width;
                      final double height = region.height;
                      final int color = annotation.color.value;

                      Provider.of<AppState>(context, listen: false)
                          .addHighlight(
                        _pdfViewerController.pageNumber ??
                            1, // Ensure non-null page number
                        Provider.of<AppState>(context, listen: false).raam,
                        x, y, width, height, color,
                      );
                    }
                  }
                },
                onTextSelectionChanged:
                    (PdfTextSelectionChangedDetails details) {
                  if (details.selectedText != null &&
                      details.selectedText!.isNotEmpty) {
                    print("Selected text: ${details.selectedText}");
                    print("Selected region: ${details.globalSelectedRegion}");

                    setState(() {
                      _selectionDetails = details;
                      Provider.of<AppState>(context, listen: false)
                          .updateData(details.selectedText!);
                    });
                  } else {
                    setState(() {
                      _selectionDetails = null; // Reset if no text is selected
                    });
                  }
                },
              ),
            ),

            // REMOVE HIGHLIGHT
            Visibility(
              visible: _textSearchKey.currentState?.showToast ?? false,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: const Text(
                    'No result',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ),

            // Highlight and Note buttons
            if (_selectionDetails != null &&
                _selectionDetails!.selectedText != null)
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.highlight, color: Colors.amber),
                      onPressed: () {
                        final Rect? region =
                            _selectionDetails!.globalSelectedRegion;
                        if (region != null) {
                          final double x = region.left;
                          final double y = region.top;
                          final double width = region.width;
                          final double height = region.height;
                          final int color = Colors.yellow.value;

                          Provider.of<AppState>(context, listen: false)
                              .addHighlight(
                            _pdfViewerController.pageNumber ??
                                1, // Ensure non-null page number
                            _selectionDetails!.selectedText!,
                            x, y, width, height, color,
                          );
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Text highlighted!")),
                        );
                        setState(() => _selectionDetails = null);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.note_add, color: Colors.blue),
                      onPressed: () {
                        if (_selectionDetails != null &&
                            _selectionDetails!.selectedText != null) {
                          _addNoteDialog(
                            _pdfViewerController.pageNumber ?? 1,
                            _selectionDetails!.selectedText!,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showHighlights() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HighlightsPage(
          urlId: "",
          pdfViewerController: _pdfViewerController,
        ),
      ),
    );

    // If a simple page number was returned instead of using the callback
    if (result != null && result is int) {
      _pdfViewerController.jumpToPage(result);
    }
  }

// Method to display highlights for the current page
  void _loadPageHighlights(int pageNumber) async {
    print("inside loading highlights after page change ");
    // Clear any existing highlight overlays
    _clearHighlightOverlays();

    // Get highlights for this page from the database
    final List<Highlight> pageHighlights =
        await _getHighlightsForPage(pageNumber);

    // If there are highlights, display them
    if (pageHighlights.isNotEmpty) {
      for (var highlight in pageHighlights) {
        _showHighlightOnPage(highlight.pageNumber, highlight.text, highlight.x,
            highlight.y, highlight.width, highlight.height, highlight.color);
      }

      print(
          "[Highlights] Loaded ${pageHighlights.length} highlights for page $pageNumber");
    } else {
      print("[Highlights] No highlights found for page $pageNumber");
    }
  }

// Helper method to fetch highlights for a specific page from the database
  Future<List<Highlight>> _getHighlightsForPage(int pageNumber) async {
    final appState = Provider.of<AppState>(context, listen: false);
    return await appState.getHighlightsForPage(pageNumber);
  }

// List to keep track of active overlay entries
  List<OverlayEntry> _activeHighlightOverlays = [];

// Remove all active highlight overlays
  void _clearHighlightOverlays() {
    for (var overlay in _activeHighlightOverlays) {
      overlay.remove();
    }
    _activeHighlightOverlays.clear();
  }

  void _showHighlightOnPage(
    int pageNumber,
    String text,
    double x,
    double y,
    double width,
    double height,
    int color,
  ) {
    final double scaleFactor = _pdfViewerController.zoomLevel;
    final double horizontalOffset = _pdfViewerController.scrollOffset.dx;

    // Apply zoom to coordinates
    final double scaledX = x * scaleFactor;
    final double scaledY = y * scaleFactor;
    final double scaledWidth = width * scaleFactor;
    final double scaledHeight = height * scaleFactor;

    // Only scroll horizontally to make highlight visible
    _pdfViewerController.jumpTo(
      xOffset: max(0, scaledX - 50),
      yOffset: _pdfViewerController
          .scrollOffset.dy, // Keep vertical position unchanged
    );

    // Add overlay
    final OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) return;

    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        // Get real-time scroll offset to update position dynamically
        final currentHorizontalOffset = _pdfViewerController.scrollOffset.dx;

        return Positioned(
          left: scaledX - currentHorizontalOffset,
          top: scaledY, // No vertical offset adjustment needed
          width: scaledWidth,
          height: scaledHeight,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: Color(color).withOpacity(0.3),
                border: Border.all(
                  color: Color(color),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
    _activeHighlightOverlays.add(overlayEntry);
  }

// Helper method to show a temporary visual indicator for the highlight
  void _showHighlightIndicator(Rect rect, Color color) {
    // We need to add an overlay entry to show the highlight indicator
    final OverlayState overlayState = Overlay.of(context);
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fromRect(
        rect: rect,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            border: Border.all(
              color: Colors.orange,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: SizedBox.expand(),
        ),
      ),
    );

    // Show the overlay
    overlayState.insert(overlayEntry);

    // Remove after a short delay
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _showNotes() async {
    final selectedPage = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NotesPage(urlId: "", pdfViewerController: _pdfViewerController)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _showToolbar
            ? AppBar(
                flexibleSpace: SafeArea(
                  child: SearchToolbar(
                    key: _textSearchKey,
                    showTooltip: true,
                    controller: _pdfViewerController,
                    onTap: (Object toolbarItem) async {
                      if (toolbarItem.toString() == 'Cancel Search') {
                        setState(() {
                          _showToolbar = false;
                          _showScrollHead = true;
                          if (Navigator.canPop(context)) {
                            Navigator.maybePop(context);
                          }
                        });
                      }
                      if (toolbarItem.toString() == 'noResultFound') {
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
                title: Text(
                  widget.title.toString(),
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
        body: Column(
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
                    icon: const Icon(
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
                    icon: const Icon(Icons.grid_view,
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
                    icon: const Icon(
                      Icons.highlight_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _showHighlights,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.note,
                      color: Colors.white,
                    ),
                    onPressed: _showNotes,
                  ),
                  IconButton(
                    icon: const Icon(
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
                ],
              ),
            )
          ],
        ) //_buildPdfViewer(),
        );
  }
}
