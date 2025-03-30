

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/search_toolbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'app_state.dart';
import 'bookmark.dart';
import 'bookmark_page.dart';
import 'grid_page.dart';
import 'highlights_page.dart';
import 'notes_page.dart';

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

  // void _saveBookmark() async {
  //   final page = _pdfViewerController.pageNumber;
  //   final bookmark = Bookmark(id: 'page_$page', pageNumber: page);
  //   await Provider.of<AppState>(context, listen: false).addBookmark(bookmark);
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text('Page $page bookmarked')));
  // }

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
              File(widget.path),
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
                ],
              ),
            )
          ],
        ) //_buildPdfViewer(),
    );
  }
}