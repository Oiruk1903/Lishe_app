import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_constants.dart';
import '../models/meal_log_model.dart';

abstract class MealLocalDataSource {
  Future<void> saveMealLog(MealLogModel meal);
  Future<List<MealLogModel>> getMealLogs(String userId,
      {DateTime? startDate, DateTime? endDate});
  Future<MealLogModel?> getMealLog(String id);
  Future<void> deleteMealLog(String id);
  Future<List<MealLogModel>> getUnsyncedLogs();
  Future<void> markAsSynced(String id);
}

class MealLocalDataSourceImpl implements MealLocalDataSource {
  final DatabaseHelper dbHelper;

  MealLocalDataSourceImpl(this.dbHelper);

  @override
  Future<void> saveMealLog(MealLogModel meal) async {
    final db = await dbHelper.database;
    await db.insert(
      DatabaseConstants.tableMealLogs,
      {
        DatabaseConstants.columnId: meal.id,
        DatabaseConstants.columnUserId: meal.userId,
        DatabaseConstants.columnFoodItemId: meal.foodId,
        DatabaseConstants.columnMealPeriod: meal.mealPeriod,
        DatabaseConstants.columnQuantity: meal.quantity,
        DatabaseConstants.columnUnit: meal.unit,
        DatabaseConstants.columnLoggedAt: meal.loggedAt.toIso8601String(),
        DatabaseConstants.columnSynced: meal.synced ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<MealLogModel>> getMealLogs(String userId,
      {DateTime? startDate, DateTime? endDate}) async {
    final db = await dbHelper.database;
    String whereClause = '${DatabaseConstants.columnUserId} = ?';
    List<dynamic> whereArgs = [userId];

    if (startDate != null && endDate != null) {
      whereClause += ' AND ${DatabaseConstants.columnLoggedAt} BETWEEN ? AND ?';
      whereArgs
          .addAll([startDate.toIso8601String(), endDate.toIso8601String()]);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMealLogs,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '${DatabaseConstants.columnLoggedAt} DESC',
    );

    return maps
        .map((map) => MealLogModel(
              id: map[DatabaseConstants.columnId] as String,
              userId: map[DatabaseConstants.columnUserId] as String,
              foodId: map[DatabaseConstants.columnFoodItemId] as String,
              mealPeriod: map[DatabaseConstants.columnMealPeriod] as String,
              quantity:
                  (map[DatabaseConstants.columnQuantity] as num).toDouble(),
              unit: map[DatabaseConstants.columnUnit] as String,
              loggedAt: DateTime.parse(
                  map[DatabaseConstants.columnLoggedAt] as String),
              synced: (map[DatabaseConstants.columnSynced] as int) == 1,
            ))
        .toList();
  }

  @override
  Future<MealLogModel?> getMealLog(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMealLogs,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    final map = maps.first;
    return MealLogModel(
      id: map[DatabaseConstants.columnId] as String,
      userId: map[DatabaseConstants.columnUserId] as String,
      foodId: map[DatabaseConstants.columnFoodItemId] as String,
      mealPeriod: map[DatabaseConstants.columnMealPeriod] as String,
      quantity: (map[DatabaseConstants.columnQuantity] as num).toDouble(),
      unit: map[DatabaseConstants.columnUnit] as String,
      loggedAt: DateTime.parse(map[DatabaseConstants.columnLoggedAt] as String),
      synced: (map[DatabaseConstants.columnSynced] as int) == 1,
    );
  }

  @override
  Future<void> deleteMealLog(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      DatabaseConstants.tableMealLogs,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<MealLogModel>> getUnsyncedLogs() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMealLogs,
      where: '${DatabaseConstants.columnSynced} = 0',
    );

    return maps
        .map((map) => MealLogModel(
              id: map[DatabaseConstants.columnId] as String,
              userId: map[DatabaseConstants.columnUserId] as String,
              foodId: map[DatabaseConstants.columnFoodItemId] as String,
              mealPeriod: map[DatabaseConstants.columnMealPeriod] as String,
              quantity:
                  (map[DatabaseConstants.columnQuantity] as num).toDouble(),
              unit: map[DatabaseConstants.columnUnit] as String,
              loggedAt: DateTime.parse(
                  map[DatabaseConstants.columnLoggedAt] as String),
              synced: false,
            ))
        .toList();
  }

  @override
  Future<void> markAsSynced(String id) async {
    final db = await dbHelper.database;
    await db.update(
      DatabaseConstants.tableMealLogs,
      {DatabaseConstants.columnSynced: 1},
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
    );
  }
}
