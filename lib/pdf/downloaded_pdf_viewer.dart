import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:osborn_book/HighLightsPage.dart';
import 'package:osborn_book/pdf/bookmark_page.dart';
import 'package:osborn_book/pdf/grid_page.dart';
import 'package:osborn_book/pdf/highlights_page.dart';
import 'package:osborn_book/pdf/models/bookmarks.dart';
import 'package:osborn_book/pdf/models/downloaded_pdf.dart';
import 'package:osborn_book/pdf/models/highlights.dart';
import 'package:osborn_book/pdf/models/local_bookmark.dart';
import 'package:osborn_book/pdf/models/local_highlight.dart';
import 'package:osborn_book/pdf/models/local_note.dart';
import 'package:osborn_book/pdf/models/notes.dart';
import 'package:osborn_book/pdf/notes_page.dart';
import 'package:osborn_book/pdf/search_toolbar.dart';
import 'package:osborn_book/pdf/service/download_service.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DownloadedPdfViewerPage extends StatefulWidget {
  final DownloadedPdf pdfData;

  const DownloadedPdfViewerPage({
    Key? key,
    required this.pdfData,
  }) : super(key: key);

  @override
  State<DownloadedPdfViewerPage> createState() => _DownloadedPdfViewerPageState();
}

class _DownloadedPdfViewerPageState extends State<DownloadedPdfViewerPage> {
  // PDF Viewer controllers and state
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  PdfTextSelectionChangedDetails? _selectionDetails;
  LocalHistoryEntry? _historyEntry;
  bool _showToolbar = false;
  bool _showScrollHead = true;

  // For annotations
  Highlight? _highlight;
  Note? _selectedNote;
  Note? _note;
  List<Note> _notes = [];
  
  // For internet connection checking
  bool hasInternetConnection = false;

  @override
  void initState() {
    super.initState();
    // Load annotations from local storage on init
    _checkInternetConnection();
    _loadHighlightsFromStorage();
    _loadNotesFromStorage();
  }

  // Check for internet connection
  Future<void> _checkInternetConnection() async {
    hasInternetConnection = await InternetConnectionChecker().hasConnection;
  }

  // Load highlights from Hive storage
  Future<void> _loadHighlightsFromStorage() async {
    final localHighlights = HiveService.getHighlightsForPdf(widget.pdfData.urlId);
    for (var highlight in localHighlights) {
      setState(() {
        // Convert LocalHighlight to a format that can be used by the PDF viewer
        List<PdfTextLine> textLines = [];
        for (var line in highlight.pdfTextLines) {
          textLines.add(
            PdfTextLine(
              Rect.fromLTWH(line.x, line.y, line.width, line.height),
              line.text,
              line.pageNumber,
            ),
          );
        }
        
        // Add highlight to the viewer when it's loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pdfViewerController.annotationMode != null) {
            _pdfViewerController.addAnnotation(
              HighlightAnnotation(textBoundsCollection: textLines),
            );
          }
        });
      });
    }
  }

  // Load notes from Hive storage
  Future<void> _loadNotesFromStorage() async {
    final localNotes = HiveService.getNotesForPdf(widget.pdfData.urlId);
    setState(() {
      _notes = localNotes.map((localNote) => localNote.toNote()).toList();
    });
    
    // Add notes to the viewer when it's loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pdfViewerController.annotationMode != null) {
        for (var note in _notes) {
          _pdfViewerController.addAnnotation(
            StickyNoteAnnotation(
              pageNumber: note.page,
              text: note.text,
              position: Offset(note.x, note.y),
              icon: PdfStickyNoteIcon.note,
            ),
          );
        }
      }
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
              BookmarksPage(pdfController: _pdfViewerController, urldId: widget.pdfData.urlId)),
    );
    if (selectedPage != null) {
      _pdfViewerController.jumpToPage(selectedPage);
    }
  }
  
  void _showHighlights() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HighlightsPage(
          pdfViewerController: _pdfViewerController,
          urlId: widget.pdfData.urlId,
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
              urlId: widget.pdfData.urlId, pdfViewerController: _pdfViewerController)),
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
              try {
                if (_note != null) {
                  // Save note locally first
                  final localNote = LocalNote.fromNote(_note!);
                  await HiveService.saveNote(widget.pdfData.urlId, localNote);
                  
                  // Add annotation to viewer
                  _pdfViewerController.addAnnotation(StickyNoteAnnotation(
                    pageNumber: pageNumber,
                    text: _note!.text,
                    position: Offset(
                      _note!.x,
                      _note!.y,
                    ),
                    icon: PdfStickyNoteIcon.note,
                  ));
                  
                  // Add to notes list
                  _notes.add(_note!);
                  
                  // Upload to server if connected
                  if (hasInternetConnection) {
                    await DownloadService.syncLocalAnnotationsToServer(widget.pdfData.urlId);
                  }
                  
                  Navigator.of(context).pop();
                }
              } catch (e) {
                log("Error adding note: $e");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Build the PDF viewer widget
  Widget _buildPdfViewer() {
    return Stack(children: [
      Column(
        children: [
          Expanded(
            child: SfPdfViewer.file(
              File(widget.pdfData.localPath),
              controller: _pdfViewerController,
              key: _pdfViewerKey,
              pageLayoutMode: PdfPageLayoutMode.single,
              
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
                    id: _selectedNote?.id,
                    publicationId: widget.pdfData.urlId,
                    page: annotation.pageNumber,
                    x: annotation.position.dx,
                    y: annotation.position.dy,
                    color: Colors.yellow.value.toString(),
                    text: annotation.text,
                  );
                  
                  try {
                    // Update local note first
                    final localNote = LocalNote.fromNote(note);
                    await HiveService.saveNote(widget.pdfData.urlId, localNote);
                    
                    // Update in notes list
                    int index = _notes.indexWhere((n) => n.id == _selectedNote?.id);
                    if (index != -1) {
                      _notes[index] = note;
                    }
                    
                    // Upload to server if connected
                    if (hasInternetConnection) {
                      await DownloadService.syncLocalAnnotationsToServer(widget.pdfData.urlId);
                    }
                  } catch (e) {
                    log("Error updating note: $e");
                  }
                }
              },
              
              // When document is loaded, annotations are already loaded in initState
              onDocumentLoaded: (details) async {
                // We can ensure annotations are properly shown after document is loaded
                await _loadHighlightsFromStorage();
                await _loadNotesFromStorage();
              },

              // When annotation is added (e.g., highlight)
              onAnnotationAdded: (Annotation annotation) async {
                if (_selectionDetails != null) {
                  if (annotation is HighlightAnnotation) {
                    try {
                      if (_highlight != null) {
                        // Save highlight locally first
                        List<PdfTextLineLocal> textLines = [];
                        for (var line in _highlight!.pdfTextLines) {
                          textLines.add(PdfTextLineLocal(
                            x: line['x'] as double,
                            y: line['y'] as double,
                            width: line['width'] as double,
                            height: line['height'] as double,
                            text: line['text'] as String,
                            pageNumber: line['pageNumber'] as int,
                          ));
                        }
                        
                        final localHighlight = LocalHighlight(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          publicationReaderId: widget.pdfData.urlId,
                          pdfTextLines: textLines,
                        );
                        
                        await HiveService.saveHighlight(
                          widget.pdfData.urlId, 
                          localHighlight
                        );
                        
                        // Upload to server if connected
                        if (hasInternetConnection) {
                          await DownloadService.syncLocalAnnotationsToServer(widget.pdfData.urlId);
                        }
                      }
                    } catch (e) {
                      log("Error creating highlight: $e");
                    }
                  }
                }
              },

              // When text selection is changed
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText != null &&
                    details.selectedText!.isNotEmpty) {
                  setState(() {
                    _selectionDetails = details;
                    
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
                      publicationId: widget.pdfData.urlId,
                      page: _pdfViewerController.pageNumber,
                      x: pdfTextLines?.first.bounds.left ?? 0,
                      y: pdfTextLines?.first.bounds.top ?? 0,
                      color: Colors.yellow.value.toString(),
                      text: _selectionDetails!.selectedText as String,
                    );

                    _highlight = Highlight(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        publicationReaderId: widget.pdfData.urlId,
                        pdfTextLines: list);
                  });
                }
              },
            ),
          ),

          // Toast for search
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
                  IconButton(
                    icon: const Icon(Icons.highlight),
                    onPressed: () {
                      final annotation = HighlightAnnotation(
                        textBoundsCollection: _pdfViewerKey.currentState?.getSelectedTextLines() ?? [],
                      );
                      _pdfViewerController.addAnnotation(annotation);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ]);
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
                      await Future.delayed(const Duration(seconds: 1));
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
                widget.pdfData.title,
                style: const TextStyle(color: Colors.white),
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
                      _ensureHistoryEntry();
                    });
                  },
                ),
                IconButton(
                  onPressed: _showBookmarks,
                  icon: const Icon(Icons.bookmark, color: Colors.white),
                ),
              ],
              automaticallyImplyLeading: true,
              backgroundColor: Colors.deepPurple,
            ),
      body: _buildPdfViewer(),
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
              onPressed: () async {
                final currentPage = _pdfViewerController.pageNumber;
                final bookmark = Bookmark(
                  page: currentPage,
                  publicationId: widget.pdfData.urlId,
                );

                try {
                  // Save bookmark locally first
                  final localBookmark = LocalBookmark.fromBookmark(bookmark);
                  await HiveService.saveBookmark(widget.pdfData.urlId, localBookmark);
                  
                  // Upload to server if connected
                  if (hasInternetConnection) {
                    await DownloadService.syncLocalAnnotationsToServer(widget.pdfData.urlId);
                  }
                  
                  Get.showSnackbar(
                    GetSnackBar(
                        duration: const Duration(seconds: 1),
                        message: 'Page $currentPage bookmarked'),
                  );
                } catch (e) {
                  log("Error creating bookmark: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
