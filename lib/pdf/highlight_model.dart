// class Highlight {
//   final int id;
//   final int pageNumber;
//   final String text;
//   final double x;
//   final double y;
//   final double width;
//   final double height;
//   final int color;
//
//   Highlight({required this.id, required this.pageNumber, required this.text,
//     required this.x, required this.y, required this.width,
//     required this.height, required this.color
//   });
// }
//


import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Model class for highlight data
class Highlight {
  final int? id; // Nullable for new entries
  final int pageNumber;
  final String text;
  final double x;
  final double y;
  final double width;
  final double height;
  final int color;

  Highlight({
    this.id,
    required this.pageNumber,
    required this.text,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
  });

  // Convert HighlightData to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageNumber': pageNumber,
      'text': text,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'color': color,
    };
  }

  // Create a HighlightData from a database map
  factory Highlight.fromMap(Map<String, dynamic> map) {
    return Highlight(
      id: map['id'],
      pageNumber: map['pageNumber'],
      text: map['text'],
      x: map['x'],
      y: map['y'],
      width: map['width'],
      height: map['height'],
      color: map['color'],
    );
  }

  // For debugging
  @override
  String toString() {
    return 'HighlightData{id: $id, pageNumber: $pageNumber, text: $text, x: $x, y: $y, width: $width, height: $height, color: $color}';
  }
}

class DatabaseHelper {
  // static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // // Singleton pattern
  // factory DatabaseHelper() => _instance;
  //
  // DatabaseHelper._internal();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'highlights.db');

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  // Create tables
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE highlights(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pageNumber INTEGER NOT NULL,
        text TEXT NOT NULL,
        x REAL NOT NULL,
        y REAL NOT NULL,
        width REAL NOT NULL,
        height REAL NOT NULL,
        color INTEGER NOT NULL
      )
    ''');
  }

  // Add a highlight to the database
  Future<int> addHighlight(Highlight highlight) async {
    final db = await database;
    return await db.insert(
      'highlights',
      highlight.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all highlights
  Future<List<Highlight>> getHighlights() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('highlights');

    return List.generate(maps.length, (i) {
      return Highlight.fromMap(maps[i]);
    });
  }

  // Get highlights for a specific page
  Future<List<Highlight>> getHighlightsByPage(int pageNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'highlights',
      where: 'pageNumber = ?',
      whereArgs: [pageNumber],
    );

    return List.generate(maps.length, (i) {
      return Highlight.fromMap(maps[i]);
    });
  }

  // Update a highlight
  Future<int> updateHighlight(Highlight highlight) async {
    final db = await database;
    return await db.update(
      'highlights',
      highlight.toMap(),
      where: 'id = ?',
      whereArgs: [highlight.id],
    );
  }

  // Delete a highlight
  Future<int> deleteHighlight(int id) async {
    final db = await database;
    return await db.delete(
      'highlights',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all highlights for a specific page
  Future<int> deleteHighlightsByPage(int pageNumber) async {
    final db = await database;
    return await db.delete(
      'highlights',
      where: 'pageNumber = ?',
      whereArgs: [pageNumber],
    );
  }
}
