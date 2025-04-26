import 'dart:io';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:osborn_book/pdf/models/bookmarks.dart';
import 'package:osborn_book/pdf/models/downloaded_pdf.dart';
import 'package:osborn_book/pdf/models/highlights.dart';
import 'package:osborn_book/pdf/models/local_bookmark.dart';
import 'package:osborn_book/pdf/models/local_highlight.dart';
import 'package:osborn_book/pdf/models/local_note.dart';
import 'package:osborn_book/pdf/models/notes.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _pdfBox = 'downloaded_pdfs';
  static const String _highlightsBox = 'pdf_highlights';
  static const String _notesBox = 'pdf_notes';
  static const String _bookmarksBox = 'pdf_bookmarks';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(DownloadedPdfAdapter());
    Hive.registerAdapter(LocalHighlightAdapter());
    Hive.registerAdapter(PdfTextLineLocalAdapter());
    Hive.registerAdapter(LocalNoteAdapter());
    Hive.registerAdapter(LocalBookmarkAdapter());
    
    // Open boxes
    await Hive.openBox<DownloadedPdf>(_pdfBox);
    await Hive.openBox<LocalHighlight>(_highlightsBox);
    await Hive.openBox<LocalNote>(_notesBox);
    await Hive.openBox<LocalBookmark>(_bookmarksBox);
  }

  // PDF Methods
  static Future<void> savePdf(DownloadedPdf pdf) async {
    final box = Hive.box<DownloadedPdf>(_pdfBox);
    await box.put(pdf.urlId, pdf);
  }

  static Future<void> deletePdf(String urlId) async {
    final box = Hive.box<DownloadedPdf>(_pdfBox);
    await box.delete(urlId);
    
    // Delete associated highlights, notes, and bookmarks
    await deleteAllHighlightsForPdf(urlId);
    await deleteAllNotesForPdf(urlId);
    await deleteAllBookmarksForPdf(urlId);
  }

  static DownloadedPdf? getPdf(String urlId) {
    final box = Hive.box<DownloadedPdf>(_pdfBox);
    return box.get(urlId);
  }

  static List<DownloadedPdf> getAllPdfs() {
    final box = Hive.box<DownloadedPdf>(_pdfBox);
    return box.values.toList();
  }

  static bool isPdfDownloaded(String urlId) {
    final box = Hive.box<DownloadedPdf>(_pdfBox);
    return box.containsKey(urlId);
  }

  // Check if PDF file exists and clean up database if not
  static Future<void> validatePdfFiles() async {
    final box = Hive.box<DownloadedPdf>(_pdfBox);
    final pdfs = box.values.toList();
    
    for (var pdf in pdfs) {
      final file = File(pdf.localPath);
      if (!await file.exists()) {
        await deletePdf(pdf.urlId);
      }
    }
  }

  // Highlight Methods
  static Future<void> saveHighlight(String pdfId, LocalHighlight highlight) async {
    final box = Hive.box<LocalHighlight>(_highlightsBox);
    final key = '${pdfId}_${highlight.id}';
    await box.put(key, highlight);
  }

  static Future<void> deleteHighlight(String pdfId, String highlightId) async {
    final box = Hive.box<LocalHighlight>(_highlightsBox);
    final key = '${pdfId}_$highlightId';
    await box.delete(key);
  }

  static List<LocalHighlight> getHighlightsForPdf(String pdfId) {
    final box = Hive.box<LocalHighlight>(_highlightsBox);
    return box.values
        .where((highlight) => highlight.publicationReaderId == pdfId)
        .toList();
  }

  static Future<void> deleteAllHighlightsForPdf(String pdfId) async {
    final box = Hive.box<LocalHighlight>(_highlightsBox);
    final keysToDelete = box.keys
        .where((key) => key.toString().startsWith('${pdfId}_'))
        .toList();
    
    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }

  // Note Methods
  static Future<void> saveNote(String pdfId, LocalNote note) async {
    final box = Hive.box<LocalNote>(_notesBox);
    final key = '${pdfId}_${note.id}';
    await box.put(key, note);
  }

  static Future<void> deleteNote(String pdfId, String noteId) async {
    final box = Hive.box<LocalNote>(_notesBox);
    final key = '${pdfId}_$noteId';
    await box.delete(key);
  }

  static List<LocalNote> getNotesForPdf(String pdfId) {
    final box = Hive.box<LocalNote>(_notesBox);
    return box.values
        .where((note) => note.publicationId == pdfId)
        .toList();
  }

  static Future<void> deleteAllNotesForPdf(String pdfId) async {
    final box = Hive.box<LocalNote>(_notesBox);
    final keysToDelete = box.keys
        .where((key) => key.toString().startsWith('${pdfId}_'))
        .toList();
    
    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }

  // Bookmark Methods
  static Future<void> saveBookmark(String pdfId, LocalBookmark bookmark) async {
    final box = Hive.box<LocalBookmark>(_bookmarksBox);
    final key = '${pdfId}_${bookmark.id ?? bookmark.page.toString()}';
    await box.put(key, bookmark);
  }

  static Future<void> deleteBookmark(String pdfId, String bookmarkId) async {
    final box = Hive.box<LocalBookmark>(_bookmarksBox);
    final key = '${pdfId}_$bookmarkId';
    await box.delete(key);
  }

  static List<LocalBookmark> getBookmarksForPdf(String pdfId) {
    final box = Hive.box<LocalBookmark>(_bookmarksBox);
    return box.values
        .where((bookmark) => bookmark.publicationId == pdfId)
        .toList();
  }

  static Future<void> deleteAllBookmarksForPdf(String pdfId) async {
    final box = Hive.box<LocalBookmark>(_bookmarksBox);
    final keysToDelete = box.keys
        .where((key) => key.toString().startsWith('${pdfId}_'))
        .toList();
    
    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }

  // Save PDF Cover Image
  static Future<String> saveCoverImage(String urlId, String imageUrl) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${appDir.path}/pdf_covers');
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }
      
      final fileName = '$urlId.jpg';
      final localPath = '${imageDir.path}/$fileName';
      final file = File(localPath);
      
      // If the file already exists, return its path
      if (await file.exists()) {
        return localPath;
      }
      
      // Otherwise, download the image
      final response = await HttpClient().getUrl(Uri.parse(imageUrl));
      final httpResponse = await response.close();
      final bytes = await httpResponse.expand((chunk) => chunk).toList();
      await file.writeAsBytes(bytes);
      
      return localPath;
    } catch (e) {
      print('Error saving cover image: $e');
      return '';
    }
  }
}
