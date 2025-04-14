// // database_manager.dart
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseManager {
//   Database? _database;
//
//   Future<void> initializeDb() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = documentsDirectory.path + "/app_data.db";
//     _database = await openDatabase(
//       path,
//       version: 2,
//       onCreate: (Database db, int version) async {
//         await db.execute(
//             "CREATE TABLE Highlights (id INTEGER PRIMARY KEY, pageNumber INTEGER, text TEXT, x REAL, y REAL, width REAL, height REAL, color INTEGER)");
//         await db.execute(
//             "CREATE TABLE Notes (id INTEGER PRIMARY KEY, pageNumber INTEGER, text TEXT, note TEXT, x REAL, y REAL, color INTEGER)");
//         await db.execute(
//             "CREATE TABLE BookMarks (id TEXT PRIMARY KEY, pageNumber INTEGER)");
//         await db.execute(
//             "CREATE TABLE Mark (id INTEGER PRIMARY KEY, pageNumber INTEGER, x REAL, y REAL)");
//       },
//
//       onUpgrade: (Database db, int oldVersion, int newVersion) async {
//         // Add a new column 'x' if it's missing
//         if (oldVersion < 2) {
//           await db.execute("ALTER TABLE Highlights ADD COLUMN x REAL");
//           await db.execute("ALTER TABLE Highlights ADD COLUMN y REAL");
//           await db.execute("ALTER TABLE Highlights ADD COLUMN width REAL");
//           await db.execute("ALTER TABLE Highlights ADD COLUMN height REAL");
//           await db.execute("ALTER TABLE Highlights ADD COLUMN color INTEGER");
//         }
//       },
//
//     );
//   }
//
//   Database? get database => _database;
// }
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  Database? _database;
  static const int DATABASE_VERSION = 1; // Start with version 1 again

  Future<void> initializeDb() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "app_data.db");

      // Check if database exists and delete it first
      if (await databaseExists(path)) {
        print("Deleting existing database");
        await deleteDatabase(path);
      }

      // Create new database with the correct schema from the beginning
      _database = await openDatabase(
        path,
        version: DATABASE_VERSION,
        onCreate: (Database db, int version) async {
          print("Creating new database with correct schema");
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

      // Verify table structure after creation
      var columnsInfo = await _database!.rawQuery('PRAGMA table_info(Highlights)');
      print("Current Highlights table columns: ${columnsInfo.map((c) => c['name']).toList()}");
    } catch (e) {
      print("Error initializing database: $e");
      // Re-throw to make the error visible
      rethrow;
    }
  }

  // Getter for database instance
  Database? get database => _database;

  // Check if database is initialized
  bool get isDatabaseInitialized => _database != null;

  // Close database
  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
