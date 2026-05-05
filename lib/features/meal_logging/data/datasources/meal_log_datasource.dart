import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_constants.dart';
import '../models/food_item_model.dart';
import '../models/meal_log_model.dart';

abstract class MealLocalDataSource {
  Future<void> saveMealLog(MealLogModel log);
  Future<List<MealLogModel>> getMealLogs(String userId, {DateTime? date});
  Future<List<FoodItemModel>> getAllFoods({String? zone, String? category});
  Future<FoodItemModel?> getFood(String id);
  Future<List<MealLogModel>> getUnsyncedLogs();
  Future<void> markAsSynced(String logId);
}

class MealLocalDataSourceImpl implements MealLocalDataSource {
  final DatabaseHelper _dbHelper;

  MealLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> saveMealLog(MealLogModel log) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseConstants.tableMealLogs,
      {
        'id': log.id,
        'user_id': log.userId,
        'food_item_id': log.foodId,
        'meal_period': log.mealPeriod,
        'quantity': log.quantity,
        'unit': log.unit,
        'logged_at': log.loggedAt.toIso8601String(),
        'synced': log.synced ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<MealLogModel>> getMealLogs(String userId,
      {DateTime? date}) async {
    final db = await _dbHelper.database;
    String whereClause = 'user_id = ?';
    List<dynamic> whereArgs = [userId];

    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      whereClause += ' AND logged_at >= ? AND logged_at < ?';
      whereArgs
          .addAll([startOfDay.toIso8601String(), endOfDay.toIso8601String()]);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMealLogs,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'logged_at DESC',
    );

    return maps
        .map((map) => MealLogModel(
              id: map['id'] as String,
              userId: map['user_id'] as String,
              foodId: map['food_item_id'] as String,
              mealPeriod: map['meal_period'] as String,
              quantity: (map['quantity'] as num).toDouble(),
              unit: map['unit'] as String,
              loggedAt: DateTime.parse(map['logged_at'] as String),
              synced: (map['synced'] as int) == 1,
            ))
        .toList();
  }

  @override
  Future<List<FoodItemModel>> getAllFoods(
      {String? zone, String? category}) async {
    final db = await _dbHelper.database;
    String? whereClause;
    List<dynamic>? whereArgs;

    final conditions = <String>[];
    if (zone != null && zone != 'all') {
      conditions.add("zone = ? OR zone = 'all'");
      whereArgs = [zone];
    }
    if (category != null) {
      conditions.add('category = ?');
      whereArgs = (whereArgs ?? [])..add(category);
    }
    if (conditions.isNotEmpty) {
      whereClause = conditions.join(' AND ');
    }

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableFoodItems,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'name_sw',
    );

    return maps
        .map((map) => FoodItemModel(
              id: map['id'] as String,
              nameSw: map['name_sw'] as String,
              nameEn: map['name_en'] as String?,
              category: map['category'] as String,
              caloriesPer100g: (map['calories_per_100g'] as num).toDouble(),
              proteinPer100g: (map['protein_per_100g'] as num).toDouble(),
              carbsPer100g: (map['carbs_per_100g'] as num).toDouble(),
              fatPer100g: (map['fat_per_100g'] as num).toDouble(),
              fiberPer100g: (map['fiber_per_100g'] as num?)?.toDouble() ?? 0,
              standardServingSize:
                  (map['standard_serving_size'] as num).toDouble(),
              servingUnit: map['serving_unit'] as String,
              zone: map['zone'] as String,
              isLocal: (map['is_local'] as int) == 1,
              imageUrl: map['image_url'] as String?,
            ))
        .toList();
  }

  @override
  Future<FoodItemModel?> getFood(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableFoodItems,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    final map = maps.first;
    return FoodItemModel(
      id: map['id'] as String,
      nameSw: map['name_sw'] as String,
      nameEn: map['name_en'] as String?,
      category: map['category'] as String,
      caloriesPer100g: (map['calories_per_100g'] as num).toDouble(),
      proteinPer100g: (map['protein_per_100g'] as num).toDouble(),
      carbsPer100g: (map['carbs_per_100g'] as num).toDouble(),
      fatPer100g: (map['fat_per_100g'] as num).toDouble(),
      fiberPer100g: (map['fiber_per_100g'] as num?)?.toDouble() ?? 0,
      standardServingSize: (map['standard_serving_size'] as num).toDouble(),
      servingUnit: map['serving_unit'] as String,
      zone: map['zone'] as String,
      isLocal: (map['is_local'] as int) == 1,
      imageUrl: map['image_url'] as String?,
    );
  }

  @override
  Future<List<MealLogModel>> getUnsyncedLogs() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMealLogs,
      where: 'synced = 0',
    );
    return maps
        .map((map) => MealLogModel(
              id: map['id'] as String,
              userId: map['user_id'] as String,
              foodId: map['food_item_id'] as String,
              mealPeriod: map['meal_period'] as String,
              quantity: (map['quantity'] as num).toDouble(),
              unit: map['unit'] as String,
              loggedAt: DateTime.parse(map['logged_at'] as String),
              synced: false,
            ))
        .toList();
  }

  @override
  Future<void> markAsSynced(String logId) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseConstants.tableMealLogs,
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [logId],
    );
  }
}
