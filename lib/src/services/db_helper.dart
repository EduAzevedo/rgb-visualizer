import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rgb_visualizer/src/models/saved_color.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}rgb_visualizer.db";

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_colors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        color INTEGER,
        hex TEXT,
        isSavedInRGB INTEGER
      )
    ''');
  }

  Future<int> insertSavedColor(SavedColor savedColor) async {
    Database db = await database;
    var result = await db.insert('saved_colors', savedColor.toMap());
    return result;
  }

  Future<List<SavedColor>> getSavedColors() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('saved_colors');

    return result.map((map) => SavedColor.fromMap(map)).toList();
  }

  Future<int> updateSavedColor(SavedColor savedColor) async {
    Database db = await database;
    return await db.update(
      'saved_colors',
      savedColor.toMap(),
      where: 'id = ?',
      whereArgs: [savedColor.toMap()['id']],
    );
  }

  Future<int> deleteSavedColor(int id) async {
    Database db = await database;
    return await db.delete('saved_colors', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllSavedColors() async {
    Database db = await database;
    return await db.delete('saved_colors');
  }

}
