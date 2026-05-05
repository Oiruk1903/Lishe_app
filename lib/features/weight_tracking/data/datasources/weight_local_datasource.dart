import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_constants.dart';
import '../models/weight_entry_model.dart';

abstract class WeightLocalDataSource {
  Future<void> saveEntry(WeightEntryModel entry);
  Future<List<WeightEntryModel>> getEntries(String userId);
  Future<WeightEntryModel?> getLatestEntry(String userId);
  Future<void> deleteEntry(String id);
  Future<List<WeightEntryModel>> getUnsyncedEntries();
  Future<void> markAsSynced(String id);
}

class WeightLocalDataSourceImpl implements WeightLocalDataSource {
  final DatabaseHelper dbHelper;

  WeightLocalDataSourceImpl(this.dbHelper);

  @override
  Future<void> saveEntry(WeightEntryModel entry) async {
    final db = await dbHelper.database;
    await db.insert(
      DatabaseConstants.tableWeightEntries,
      {
        'id': entry.id,
        'user_id': entry.userId,
        'weight': entry.weight,
        'recorded_at': entry.recordedAt.toIso8601String(),
        'synced': entry.synced ? 1 : 0,
        'note': entry.note,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<WeightEntryModel>> getEntries(String userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableWeightEntries,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at ASC',
    );
    return maps
        .map((map) => WeightEntryModel(
              id: map['id'] as String,
              userId: map['user_id'] as String,
              weight: (map['weight'] as num).toDouble(),
              recordedAt: DateTime.parse(map['recorded_at'] as String),
              synced: (map['synced'] as int) == 1,
              note: map['note'] as String?,
            ))
        .toList();
  }

  @override
  Future<WeightEntryModel?> getLatestEntry(String userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableWeightEntries,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final map = maps.first;
    return WeightEntryModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      weight: (map['weight'] as num).toDouble(),
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      synced: (map['synced'] as int) == 1,
      note: map['note'] as String?,
    );
  }

  @override
  Future<void> deleteEntry(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      DatabaseConstants.tableWeightEntries,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<WeightEntryModel>> getUnsyncedEntries() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableWeightEntries,
      where: 'synced = 0',
    );
    return maps
        .map((map) => WeightEntryModel(
              id: map['id'] as String,
              userId: map['user_id'] as String,
              weight: (map['weight'] as num).toDouble(),
              recordedAt: DateTime.parse(map['recorded_at'] as String),
              synced: false,
              note: map['note'] as String?,
            ))
        .toList();
  }

  @override
  Future<void> markAsSynced(String id) async {
    final db = await dbHelper.database;
    await db.update(
      DatabaseConstants.tableWeightEntries,
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
