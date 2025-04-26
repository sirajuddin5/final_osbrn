import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osborn_book/pdf/service/download_service.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:osborn_book/pdf/models/base_response_model.dart';
import 'package:osborn_book/pdf/models/bookmarks.dart';
import 'package:osborn_book/pdf/models/notes.dart';
import 'package:osborn_book/pdf/search_toolbar.dart';
import 'package:osborn_book/pdf/service/bookmark_service.dart';
import 'package:osborn_book/pdf/service/highlight_service.dart';
import 'package:osborn_book/pdf/service/notes_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../HighLightsPage.dart';
import 'app_state.dart';
import 'bookmark_page.dart';
import 'grid_page.dart';
import 'highlights_page.dart';
import 'models/highlights.dart';
import 'notes_page.dart';

class PdfViewerPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String url;
  final String urlToPdf;
  final String urlId;

  const PdfViewerPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.url,
    required this.urlToPdf,
    required this.urlId,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String pdfPath = ''; // Store the local path of the cached PDF.
  bool isLoading = true;
  double downloadProgress = 0.0; // Variable to track the download progress.
  bool isDownloaded = false; // Track if the file is downloaded to app storage
  bool showDialogOnce = false; // Prevent multiple dialog calls

  //// copied code
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  PdfTextSelectionChangedDetails? _selectionDetails;
  late bool _showToolbar;
  late bool _showScrollHead;
  LocalHistoryEntry? _historyEntry;
  bool shouldUpdateHighlight = false;
  bool shouldUpdateNote = false;

  final HighlightService highlightService = HighlightService();
  final NoteService noteService = NoteService();

  Future<void> initializeDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "app_data.db";
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create new tables
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

  void ensureHistoryEntry() {
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
          builder: (context) => BookmarksPage(
                pdfController: _pdfViewerController,
                urldId: widget.urlId,
              )),
    );
    if (selectedPage != null) {
      _pdfViewerController.jumpToPage(selectedPage);
    }
  }

  updateHighlights() async {
    try {
      final res = await highlightService.getHighlights(widget.urlId);
      log("log message " + res.toString());

      if (res.status ?? false) {
        for (var d in res.data!) {
          List<PdfTextLine> list = [];
          for (var t in d.pdfTextLines) {
            list.add(PdfTextLine(
                Rect.fromLTWH(t["x"], t["y"], t["width"], t["height"]),
                t["text"],
                t["pageNumber"]));
          }

          final high = HighlightAnnotation(textBoundsCollection: list);
          _pdfViewerController.addAnnotation(high);
        }
      } else {
        log("No highlights found");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  updateNotes() async {
    try {
      final noteRes = await noteService.getNotes(widget.urlId);
      if (noteRes.status ?? false) {
        for (var d in noteRes.data!) {
          _notes.add(d);
          _pdfViewerController.addAnnotation(
            StickyNoteAnnotation(
              pageNumber: d.page,
              text: d.text,
              position: Offset(d.x, d.y),
              icon: PdfStickyNoteIcon.note,
            ),
          );
        }
      } else {
        log("No notes found");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  late List<int> myanno;

  Highlight? _highlight;
  Note? _selectedNote;
  Note? _note;
  List<Note> _notes = [];

  Widget _buildPdfViewer() {
    return Stack(children: [
      Column(
        children: [
          Expanded(
            child: SfPdfViewer.file(
              onAnnotationSelected: (annotation) {
                if (annotation is StickyNoteAnnotation) {
                  _selectedNote = _notes.firstWhere((note) {
                    if (note.page == annotation.pageNumber &&
                        note.x == annotation.position.dx &&
                        note.y == annotation.position.dy) {
                      return true;
                    }
                    return false;
                  });
                }
              },
              onAnnotationEdited: (annotation) async {
                if (annotation is StickyNoteAnnotation) {
                  final note = Note(
                    publicationId: widget.urlId,
                    page: annotation.pageNumber,
                    x: annotation.position.dx,
                    y: annotation.position.dy,
                    color: Colors.yellow.value.toString(),
                    text: annotation.text,
                  );
                  try {
                    await noteService.updateNote(_selectedNote!.id!, note);
                    Get.showSnackbar(const GetSnackBar(
                        duration: Duration(seconds: 1),
                        message: "Note Updated"));
                  } catch (e) {
                    log("Error updating note: $e");
                  }
                }
              },
              onDocumentLoaded: (details) async {
                await updateHighlights();
                await updateNotes();
              },
              File(pdfPath),
              controller: _pdfViewerController,
              key: _pdfViewerKey,
              pageLayoutMode: PdfPageLayoutMode.single,

              // When annotation is added (e.g., highlight)
              onAnnotationAdded: (Annotation annotation) async {
                log("[Highlight Specifications] Annotation Added: $annotation");
                log("[Highlight Specifications] Current Page Number: ${_pdfViewerController.pageNumber}");
                log("[Highlight Specifications] Raam Value: ${Provider.of<AppState>(context, listen: false).raam}");

                // Update the state with the new highlight
                if (_selectionDetails != null) {
                  final Rect? region = _selectionDetails!.globalSelectedRegion;

                  if (annotation is HighlightAnnotation) {
                    if (region != null) {
                      final double x = region.left;
                      final double y = region.top;
                      final double width = region.width;
                      final double height = region.height;
                      final int color = annotation.color.value;

                      try {
                        if (_highlight != null) {
                          log("==============================================");
                          log(_highlight!.publicationReaderId.toString());
                          final res = await highlightService
                              .createHighlight(_highlight!);

                          if (res.status ?? false) {
                            _highlight = null;
                            shouldUpdateHighlight = true;
                            // await updateHighlights();
                            // await updateNotes();
                            Get.showSnackbar(
                              const GetSnackBar(
                                  duration: Duration(seconds: 1),
                                  message: "Highlight Created Successfully"),
                            );
                          }
                        }
                      } catch (e) {
                        log("Error creating highlight: $e");
                      }

                      // Provider.of<AppState>(context, listen: false).addHighlight(
                      //   _pdfViewerController.pageNumber ??
                      //       1, // Ensure non-null page number
                      //   Provider.of<AppState>(context, listen: false).raam,
                      //   x, y, width, height, color,
                      // );
                    }
                  }
                }
              },

              // When text selection is changed
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                log("[Text Selection Specifications] Text Selection Changed! ${widget.urlId}");
                log("[Text Selection Specifications] Selected Text: ${details.selectedText}");
                log("[Text Selection Specifications] Global Selected Region: ${details.globalSelectedRegion}");
                log("[Text Selection Specifications] Text Selection Details: ${details.toString()}");

                if (details.selectedText != null &&
                    details.selectedText!.isNotEmpty) {
                  setState(() {
                    _selectionDetails = details;
                    log("[Text Selection Specifications] Updating Data with Selected Text: ${_selectionDetails!.selectedText}");

                    // Update the state with the selected text
                    Provider.of<AppState>(context, listen: false)
                        .updateData(_selectionDetails!.selectedText as String);

                    List<PdfTextLine>? pdfTextLines =
                        _pdfViewerKey.currentState?.getSelectedTextLines();

                    List<Map<String, dynamic>> list = [];

                    for (var line in pdfTextLines ?? []) {
                      var map = <String, dynamic>{};
                      map['pageNumber'] = _pdfViewerController.pageNumber;
                      map['text'] = line.text;
                      map['x'] = line.bounds.left;
                      map['y'] = line.bounds.top;
                      map['width'] = line.bounds.width;
                      map['height'] = line.bounds.height;
                      list.add(map);
                    }

                    _note = Note(
                      publicationId: widget.urlId,
                      page: _pdfViewerController.pageNumber,
                      x: pdfTextLines?.first.bounds.left ?? 0,
                      y: pdfTextLines?.first.bounds.top ?? 0,
                      color: Colors.yellow.value.toString(),
                      text: _selectionDetails!.selectedText as String,
                    );

                    _highlight = Highlight(
                        id: '',
                        publicationReaderId: widget.urlId,
                        pdfTextLines: list);
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
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, top: 7, right: 15, bottom: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: const Text(
                      'No result',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Display the row of icons (highlight and add note)
          if (_selectionDetails != null &&
              _selectionDetails!.selectedText != null)
            Container(
              color: Colors.grey[200],
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.note_add),
                    onPressed: () {
                      log("[Note Specifications] Adding Note for Text: ${_selectionDetails!.selectedText}");

                      // Open the note dialog for adding a note
                      _addNoteDialog(
                        _pdfViewerController.pageNumber,
                        _selectionDetails!.selectedText!,
                      );
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HighlightsPage(
          // Pass the highlights data to HighlightsPage
          pdfViewerController: _pdfViewerController,
          urlId: widget.urlId,
        ),
      ),
    );

    // If a simple page number was returned instead of using the callback
    if (result != null && result is int) {
      _pdfViewerController.jumpToPage(result);
    }
  }

  void _showNotes() async {
    final selectedPage = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotesPage(
              urlId: widget.urlId, pdfViewerController: _pdfViewerController)),
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
        title: const Text("Add a Note"),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(hintText: "Enter your note here"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // await Provider.of<AppState>(context, listen: false).addNote(
              //   pageNumber,
              //   selectedText,
              //   noteController.text,
              // );
              try {
                final BaseResponseModel<Note>? res;
                if (_note != null) {
                  res = await noteService.createNote(
                    _note!,
                  );
                } else {
                  return;
                }
                // shouldUpdateNote = true;
                // await updateNotes();
                Get.showSnackbar(const GetSnackBar(
                    duration: Duration(seconds: 1),
                    message: "Note Added Successfully"));
                _pdfViewerController.addAnnotation(StickyNoteAnnotation(
                  pageNumber: pageNumber,
                  text: _note!.text,
                  position: Offset(
                    _note!.x,
                    _note!.y,
                  ),
                  icon: PdfStickyNoteIcon.note,
                ));
                _notes.add(res.data!);

                Navigator.of(context).pop();
              } catch (e) {
                log("Error adding note: $e");
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text("Failed to add note:")));
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _showToolbar = false;
    _showScrollHead = true;
    super.initState();
    // initializeDb();
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
          title: const Text('No PDF Available'),
          content: const Text('Currently, no PDF is available.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
      // Use DownloadService to properly save the PDF with metadata for Hive storage
      final success = await DownloadService.downloadPdf(
        urlId: widget.urlId,
        title: widget.title,
        pdfUrl: widget.urlToPdf,
        coverUrl: widget.imagePath,
      );

      if (success) {
        setState(() {
          isDownloaded = true;
        });
      } else {
        showErrorDialog('Failed to download PDF. Please try again.');
      }
    } catch (e) {
      log('Error downloading PDF: $e');
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
              title: const Text(
                "Osborne",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _showScrollHead = false;
                      _showToolbar = true;
                      ensureHistoryEntry();
                    });
                  },
                ),
                IconButton(
                  onPressed: _showBookmarks,
                  icon: const Icon(Icons.bookmark, color: Colors.white),
                ),
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
                  const SizedBox(height: 20),
                  CircularProgressIndicator(value: downloadProgress / 100),
                ],
              ),
            )
          : widget.urlToPdf.isEmpty
              ? Center(
                  child: Image.network(
                      widget.imagePath)) // Display the image if no PDF
              : Column(
                  children: [
                    Expanded(child: _buildPdfViewer()),
                    Container(
                      color: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
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
                            icon: const Icon(
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
                            onPressed: () async {
                              final currentPage =
                                  _pdfViewerController.pageNumber;
                              final bookmark = Bookmark(
                                page: currentPage,
                                publicationId: widget.urlId,
                              );

                              final bookmarkService = BookmarkService();
                              try {
                                await bookmarkService.createBookmark(
                                  bookmark,
                                );
                                Get.showSnackbar(
                                  GetSnackBar(
                                      duration: Duration(seconds: 1),
                                      message: 'Page $currentPage bookmarked'),
                                );
                              } catch (e) {
                                log("Error creating bookmark: $e");
                              }

                              // Provider.of<AppState>(context, listen: false)
                              //     .addBookmark(bookmark)
                              //     .then((_) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content:
                              //             Text('Page $currentPage bookmarked')),
                              //   );
                              // });
                            },
                          ),
                          IconButton(
                            icon: const Icon(
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
