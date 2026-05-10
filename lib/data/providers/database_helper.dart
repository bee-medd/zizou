import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pdf_chunk.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ananpath.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pdf_chunks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        type TEXT NOT NULL,
        imagePath TEXT,
        description TEXT,
        pageNumber INTEGER NOT NULL,
        sourceFile TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertChunk(PDFChunk chunk) async {
    final db = await instance.database;
    return await db.insert('pdf_chunks', chunk.toMap());
  }

  Future<List<PDFChunk>> queryChunks(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'pdf_chunks',
      where: 'content LIKE ?',
      whereArgs: ['%$query%'],
    );

    return result.map((json) => PDFChunk.fromMap(json)).toList();
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('pdf_chunks');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
