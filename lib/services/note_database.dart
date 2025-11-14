// lib/services/note_database.dart
// note_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';

class NoteDatabase {
  static Database? _db;
  static const int _dbVersion = 2; // bump to 2 pour migration

  //Eviter de repeter la base de donnees et consever la connexion
  NoteDatabase._privateConstructor();
  static final NoteDatabase instance = NoteDatabase._privateConstructor();

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id TEXT PRIMARY KEY,
            userId INTEGER,
            title TEXT,
            content TEXT,
            createdAt TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Si on vient d'une version 1 -> ajoute la colonne title
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE notes ADD COLUMN title TEXT;');
        }
        // futures migrations ici
      },
    );
  }

  Future<void> insertNote(Note note) async {
    final db = await NoteDatabase.database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotesByUser(String userId) async {
    final db = await NoteDatabase.database;
    final res = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return res.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> updateNote(Note note) async {
    final db = await NoteDatabase.database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await NoteDatabase.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}

// import 'package:projet_dclic/services/user_database.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:projet_dclic/models/note.dart';
//
// class NoteDatabase {
//   //declaration des propriétes statiques
//   static Database? _database;
//   static const String _databaseName = "todo_app.db";
//   static const int _databaseVersion = 1;
//   //
//   // static const String tableNotes = 'notes';
//   // static const String columnId = 'id';
//   // static const String columnTitle = 'title';
//   // static const String columnContent = 'content';
//   // static const String columnCreatedAt = 'createdAt';
//
//   //Eviter de repeter la base de donnees et consever la connexion
//   NoteDatabase._privateConstructor();
//   static final NoteDatabase instance = NoteDatabase._privateConstructor();
//
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   //initilisation de la base de donnes
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), _databaseName);
//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//     );
//   }
//
//   //creation de la base de donnees
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//        CREATE TABLE notes (
//       id TEXT PRIMARY KEY,
//       userId TEXT,
//       content TEXT,
//       createdAt TEXT
//     )
//     ''');
//   }
//
//   //mise en place du crud de notes
//
//   Future<void> insertNote(Note note) async {
//     final db = await instance.database;
//     await db.insert(
//       'notes',
//       note.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<List<Note>> getNotesByUser(String userId) async {
//     final db = await instance.database;
//     final res = await db.query(
//       'notes',
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//     return res.map((e) => Note.fromMap(e)).toList();
//   }
//
//   Future<void> updateNote(Note note) async {
//     final db = await instance.database;
//     await db.update(
//       'notes',
//       note.toMap(),
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//   }
//
//   Future<void> deleteNote(String id) async {
//     final db = await instance.database;
//     await db.delete('notes', where: 'id = ?', whereArgs: [id]);
//   }
// }
