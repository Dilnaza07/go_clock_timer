import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import '../../../../../core/database/timer_database.dart';
import '../models/timer_entity.dart';

class TimerDbService {
  static const tableName = 'timers';
  static const columnIncrement = 'increment';
  static const columnId = 'id';
  static const columnTime = 'time';
  static const columnPeriods = 'periods';

  final TimerDatabase _timerDatabase;

  TimerDbService({required TimerDatabase notesDatabase}) : _timerDatabase = notesDatabase;

  Future<int> insertTimer(TimerEntity entity) async {
    final database = await _timerDatabase.database;
    print(entity);
    debugPrint('$entity');
    return database.insert(tableName, entity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TimerEntity>> getTimers() async {
    final db = await _timerDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return maps.map((e) => TimerEntity.fromJson(e)).toList();
  }

  Future<TimerEntity?> getTimerById(int id) async {
    final db = await _timerDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '${columnId} = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? TimerEntity.fromJson(maps[0]) : null;
  }
}
