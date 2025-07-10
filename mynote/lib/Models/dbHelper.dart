import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'noteModel.dart';

class DatabaseHelper {
  // ——— singleton boilerplate ———
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('app.db');
    return _db!;
  }

  // ——— open / create DB ———
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // SQLite doesn’t have a native BOOLEAN type; use INTEGER 0 / 1.
    await db.execute('''
      CREATE TABLE notes (
        noteId   INTEGER PRIMARY KEY AUTOINCREMENT,
        noteDt   TEXT    NOT NULL,
        stat     INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // ——— CRUD helpers ———

  /// Insert a new note. Returns the generated noteId.
  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  /// Fetch a single note by its ID; returns null if not found.
  Future<Note?> getNoteById(int noteId) async {
    final db = await database;
    final res = await db.query(
      'notes',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }

  /// Fetch all notes sorted by latest first.
  Future<List<Note>> getNotesByStatus(bool locked) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'stat = ?',
      whereArgs: [locked ? 1 : 0],
      orderBy: 'noteId DESC',
    );
    return result.map((m) => Note.fromMap(m)).toList();
  }

  /// set the `stat` field (true = 1, false = 0).
  Future<int> updateNoteStatus(int noteId, bool stat) async {
    final db = await database;
    return await db.update(
      'notes',
      {'stat': stat ? 1 : 0},
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
  }

  /// Delete a note permanently. Returns number of rows removed (0 or 1).
  Future<int> deleteNote(int noteId) async {
    final db = await database;
    return await db.delete('notes', where: 'noteId = ?', whereArgs: [noteId]);
  }

  /// Update the content (Delta JSON) of an existing note.
  Future<int> updateNoteContent(int noteId, String deltaJson) async {
    final db = await database;
    return db.update(
      'notes',
      {'noteDt': deltaJson},
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
  }

  getAllNotes(bool bool) {}

  deleteUser(int noteId) {}
}
