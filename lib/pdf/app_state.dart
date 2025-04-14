import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'highlight_model.dart';
import 'bookmark.dart';


class AppState extends ChangeNotifier {
  List<Highlight> _highlights = [];
  List<Bookmark> bookmarks = [];
  Database? database;

  List<Highlight> get highlights => _highlights;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String raam = '';

  void updateData(String newData) {
    raam = newData;
    notifyListeners(); // Notify listeners to update the UI
  }

  void updateRegion(String newData) {
    raam = newData;
    notifyListeners(); // Notify listeners to update the UI
  }
  void setDatabase(Database db) {
    database = db;
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    if (database == null) return;

    final List<Map<String, dynamic>> highlightsResult =
    await database!.query('Highlights');
    _highlights = highlightsResult
        .map((e) => Highlight(
      id: e['id'],
      pageNumber: e['pageNumber'],
      text: e['text'],
      x: e['x'],
      y: e['y'],
      width: e['width'],
      height: e['height'],
      color: e['color'],

    )).toList();

    final List<Map<String, dynamic>> bookmarksResult =
    await database!.query('BookMarks');
    bookmarks = bookmarksResult
        .map((e) =>
        Bookmark(id: e['id'].toString(), pageNumber: e['pageNumber']))
        .toList();

    notifyListeners();
  }



  // Future<void> addHighlight(int pageNumber, String text, double x, double y, double width, double height, int color) async {
  //   if (database == null) return;
  //
  //   final id = await database!.insert('Highlights', {
  //     'pageNumber': pageNumber,
  //     'text': text,
  //     'x': x,
  //     'y': y,
  //     'width': width,
  //     'height': height,
  //     'color': color,
  //   });
  //   highlights.add(Highlight(
  //     id: id,
  //     pageNumber: pageNumber,
  //     text: text,
  //     x: x,
  //     y: y,
  //     width: width,
  //     height: height,
  //     color: color,
  //   ));

  //new onne

  Future<void> addHighlight(
      int pageNumber,
      String text,
      double x,
      double y,
      double width,
      double height,
      int color,
      ) async {
    // Create highlight data object
    final highlight = Highlight(
      pageNumber: pageNumber,
      text: text,
      x: x,
      y: y,
      width: width,
      height: height,
      color: color,
    );

    // Add to database
    final id = await _databaseHelper.addHighlight(highlight);

    // Create a copy with the assigned ID
    final savedHighlight = Highlight(
      id: id,
      pageNumber: pageNumber,
      text: text,
      x: x,
      y: y,
      width: width,
      height: height,
      color: color,
    );

    // Add to in-memory list
    _highlights.add(savedHighlight);

    //_pdfViewerController.addAnnotation(highlightAnnotation);

    notifyListeners();

    print("[AppState] Highlight saved: Page $pageNumber, Text: $text");
  }

  //TODO get highlights

  // List of highlights in memory


  // Method to fetch all highlights from database original one
  // Future<void> loadAllHighlights() async {
  //   _highlights = await _databaseHelper.getHighlights();
  //   notifyListeners();
  // }

  // Method to get highlights for a specific page original one
  // Future<List<Highlight>> getHighlightsForPage(int pageNumber) async {
  //   final List<Highlight> pageHighlights = await _databaseHelper.getHighlightsByPage(pageNumber);
  //   return pageHighlights;
  // }

  // Initialize the state (call this during app startup)
  Future<void> initialize() async {
    await loadAllHighlights();
  }

  // Load all highlights from database
  Future<void> loadAllHighlights() async {
    _highlights = await _databaseHelper.getHighlights();
    print("[AppState] Loaded ${_highlights.length} highlights from database");
    notifyListeners();
  }

  // Get highlights for a specific page
  Future<List<Highlight>> getHighlightsForPage(int pageNumber) async {
    return await _databaseHelper.getHighlightsByPage(pageNumber);
  }

  // Delete a highlight
  Future<void> deleteHighlight(int highlightId) async {
    await _databaseHelper.deleteHighlight(highlightId);
    _highlights.removeWhere((highlight) => highlight.id == highlightId);
    notifyListeners();
    print("[AppState] Highlight deleted: ID $highlightId");
  }

  Future<void> removeHighlight(int id) async {
    if (database == null) return;

    await database!.delete('Highlights', where: 'id = ?', whereArgs: [id]);
    highlights.removeWhere((highlight) => highlight.id == id);
    notifyListeners();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    if (database == null) return;

    await database!.insert('BookMarks', {
      'id': bookmark.id,
      'pageNumber': bookmark.pageNumber,
    });
    bookmarks.add(bookmark);
    notifyListeners();
  }

  Future<void> removeBookmark(String id) async {
    if (database == null) return;

    await database!.delete('BookMarks', where: 'id = ?', whereArgs: [id]);
    bookmarks.removeWhere((bookmark) => bookmark.id == id);
    notifyListeners();
  }

  Future<void> addNote(int pageNumber, String text, String note) async {
    if (database == null) return;

    await database!.insert('Notes', {
      'pageNumber': pageNumber,
      'text': text,
      'note': note,
      'x': 0.0, // You might want to add actual x, y coordinates
      'y': 0.0,
      'color': 0, // Default color, you might want to add an actual color
    });

    notifyListeners();
  }

  Future<void> removeNote(int id) async {
    if (database == null) return;

    await database!.delete('Notes', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    if (database == null) return [];

    return await database!.query('Notes');
  }
}
