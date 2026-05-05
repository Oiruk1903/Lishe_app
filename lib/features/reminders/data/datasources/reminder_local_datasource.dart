import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_constants.dart';
import '../models/reminder.dart';

class ReminderLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> saveReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseConstants.tableReminders,
      reminder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Reminder>> getReminders(String userId,
      {bool? isCompleted}) async {
    final db = await _dbHelper.database;

    String whereClause = '${DatabaseConstants.columnUserId} = ?';
    List<dynamic> whereArgs = [userId];

    if (isCompleted != null) {
      whereClause += ' AND ${DatabaseConstants.columnIsCompleted} = ?';
      whereArgs.add(isCompleted ? 1 : 0);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableReminders,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '${DatabaseConstants.columnScheduledFor} ASC',
    );

    return maps.map((map) => Reminder.fromMap(map)).toList();
  }

  Future<List<Reminder>> getUpcomingReminders(String userId) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableReminders,
      where: '${DatabaseConstants.columnUserId} = ? AND '
          '${DatabaseConstants.columnScheduledFor} >= ? AND '
          '${DatabaseConstants.columnIsCompleted} = 0',
      whereArgs: [userId, now],
      orderBy: '${DatabaseConstants.columnScheduledFor} ASC',
    );

    return maps.map((map) => Reminder.fromMap(map)).toList();
  }

  Future<void> markAsCompleted(String reminderId) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseConstants.tableReminders,
      {DatabaseConstants.columnIsCompleted: 1},
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [reminderId],
    );
  }

  Future<void> deleteReminder(String reminderId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseConstants.tableReminders,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [reminderId],
    );
  }

  Future<List<Reminder>> getUnsyncedReminders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableReminders,
      where: '${DatabaseConstants.columnSynced} = 0',
    );
    return maps.map((map) => Reminder.fromMap(map)).toList();
  }
}
