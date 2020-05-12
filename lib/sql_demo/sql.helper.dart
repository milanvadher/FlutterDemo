import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'note.model.dart';

class SQLHelper {
  static Database _database;
  static String _databaseName = 'note_database.db';
  static int _databaseVersion = 1;
  static String tableName = 'notes';
  static String columnId = 'id';
  static String columnTitle = 'title';
  static String columnDiscription = 'discription';
  static String columnCreatedAt = 'createdAt';
  static String columnUpdatedAt = 'updatedAt';

  // make this a singleton class
  SQLHelper._privateConstructor();
  static final SQLHelper instance = SQLHelper._privateConstructor();

  // this return database
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(
      documentsDirectory.path,
      _databaseName,
    );
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onDbCreate,
    );
  }

  // SQL code to create the database table
  _onDbCreate(Database db, int version) {
    return db.execute(
      '''CREATE TABLE $tableName(
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $columnTitle TEXT NOT NULL, 
          $columnDiscription TEXT, 
          $columnCreatedAt TEXT NOT NULL, 
          $columnUpdatedAt TEXT NOT NULL
        )''',
    );
  }

  // Define a function that inserts notes into the database
  Future<void> insertNote(Note note) async {
    // Get a reference to the database.
    final Database db = await instance.database;

    String now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    note.createdAt = now;
    note.updatedAt = now;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same note is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that update note into the database
  Future<void> updateNote(Note note) async {
    // Get a reference to the database.
    final Database db = await instance.database;

    note.updatedAt = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

    // Update the given Note.
    await db.update(
      tableName,
      note.toMap(),
      // Ensure that the Note has a matching id.
      where: "$columnId = ?",
      // Pass the Note's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int noteId) async {
    // Get a reference to the database.
    final Database db = await instance.database;

    // Remove the Note from the Database.
    await db.delete(
      tableName,
      where: "$columnId = ?",
      whereArgs: [noteId],
    );
  }

  // A method that retrieves all the notes from the notes table.
  Future<List<Note>> fetchNotes() async {
    // Get a reference to the database.
    final Database db = await instance.database;
    // Query the table for all The Notes.
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, orderBy: '$columnUpdatedAt DESC');
    // Convert the List<Map<String, dynamic> into a List<Note>.
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        discription: maps[i]['discription'],
        createdAt: maps[i]['createdAt'],
        updatedAt: maps[i]['updatedAt'],
      );
    }).toList();
  }
}
