// lib/core/database/book_db_helper.dart
import 'package:book_finder/features/books/data/models/book_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BookDbHelper {
  static late Database _db;

  static Future<void> init() async {
    final path = join(await getDatabasesPath(), 'book_finder.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE books(id TEXT PRIMARY KEY, title TEXT, author TEXT, thumbnail TEXT, description TEXT)',
        );
      },
    );
  }

  static Future<void> saveBook(Map<String, dynamic> book) async {
    await _db.insert(
      'books',
      book,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getBooks() async {
    return await _db.query('books');
  }
}
