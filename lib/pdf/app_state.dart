import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'highlight_model.dart';
import 'bookmark.dart';


class AppState extends ChangeNotifier {
  List<Highlight> highlights = [];
  List<Bookmark> bookmarks = [];
  Database? database;

  String raam = '';

  void updateData(String newData) {
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
    highlights = highlightsResult
        .map((e) => Highlight(
      id: e['id'],
      pageNumber: e['pageNumber'],
      text: e['text'],
    ))
        .toList();

    final List<Map<String, dynamic>> bookmarksResult =
    await database!.query('BookMarks');
    bookmarks = bookmarksResult
        .map((e) =>
        Bookmark(id: e['id'].toString(), pageNumber: e['pageNumber']))
        .toList();

    notifyListeners();
  }

  Future<void> addHighlight(int pageNumber, String text) async {
    if (database == null) return;

    final id = await database!.insert('Highlights', {
      'pageNumber': pageNumber,
      'text': text,
    });
    highlights.add(Highlight(id: id, pageNumber: pageNumber, text: text));

    //_pdfViewerController.addAnnotation(highlightAnnotation);

    notifyListeners();
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
