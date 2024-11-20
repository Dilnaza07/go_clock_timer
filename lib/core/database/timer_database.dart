import 'package:go_clock/features/settings/data/database/service/timer_db_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';


class TimerDatabase {
  static const String _databaseName = 'timer.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: _databaseVersion,
     // onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('\#\#\# _onCreate');

    // await db.execute(
    //     '''CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)''');

    await db.execute('''CREATE TABLE ${TimerDbService.tableName}(
    ${TimerDbService.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, 
    ${TimerDbService.columnTime} INTEGER,
    ${TimerDbService.columnPeriods} INTEGER,
    ${TimerDbService.columnIncrement} INTEGER
    )
    ''');
  }
}
