import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlitesmartherdnotesapp/models/model.dart';

import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Database Helper Singleton
  static Database _database; //its database Singleton Which creates once
  String tableName = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colPriority = 'priority';
  String colDate = 'date';
  String colDescription = 'description';
  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  //Here I am creating database reference Variable
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Here Database is open to path
  Future<Database> initializeDatabase() async {
    //providing path to the Database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    //Here we are Open the database
    var notesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  //Here Database Is created
  void _createDb(Database db, int newVersion) async {
    db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT $colTitle TEXT $colPriority INTEGER $colDescription TEXT $colDate TEXT)');
  }

  //Fetch Operation:Get all objects fro note
  Future<List<Map<String, dynamic>>> getMapData() async {
    Database db = await this.database;
    var result = db.query(tableName, orderBy: '$colPriority ASC');

    return result;
  }

//Insert Operation: Insert object to the note
  Future<int> insertNote(Note model) async {
    Database db = await this.database;
    var result = db.insert(tableName, model.toMap());
    return result;
  }

  // Update operation:update object into note
  Future<int> updateData(Note model) async {
    Database db = await this.database;
    var result = await db.update(tableName, model.toMap(),
        whereArgs: [model.id], where: '$colId = ?');
    return result;
  }

//Delete Operation:Delete object int note
  Future<int> deleteData(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM  WHERE $colId = $id ');
    return result;
  }

//Count all objects into the node
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Now get Map from the fetch method and convert it into List
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getMapData(); //getting the map List int variable
    int count = noteMapList.length; //getting the number of entries in database
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
