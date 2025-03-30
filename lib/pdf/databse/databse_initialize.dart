// database_manager.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  Database? _database;

  Future<void> initializeDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "/app_data.db";
    _database = await openDatabase(
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
  }

  Database? get database => _database;
}
