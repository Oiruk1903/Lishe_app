import '../../domain/repositories/meal_repository.dart';
import '../../domain/entities/meal_entry.dart';
import '../../domain/entities/food.dart';
import '../datasources/meal_local_datasource.dart';
import '../datasources/meal_remote_datasource.dart';
import '../models/food_item_model.dart';
import '../models/meal_log_model.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_constants.dart';

class MealRepositoryImpl implements MealRepository {
  final MealLocalDataSource localDataSource;
  final MealRemoteDataSource remoteDataSource;
  final DatabaseHelper dbHelper;

  MealRepositoryImpl(this.localDataSource, this.remoteDataSource, this.dbHelper);

  @override
  Future<void> logMeal(MealEntry entry) async {
    final model = MealLogModel.fromEntity(entry);

    // Optimistically save locally first
    await localDataSource.saveMealLog(model);

    // Fire-and-forget sync to remote
    try {
      await remoteDataSource.logMeal({
        'foodId': entry.foodId,
        'mealPeriod': entry.mealPeriod.name,
        'quantity': entry.quantity,
        'unit': entry.unit,
        'loggedAt': entry.loggedAt.toIso8601String(),
      });
      await localDataSource.markAsSynced(entry.id);
    } catch (_) {
      // Will be retried by syncPendingMeals()
    }
  }

  @override
  Future<List<MealEntry>> getUserMeals(String userId, {DateTime? date}) async {
    // Try remote first; fall back to local on failure
    try {
      final dateStr = date != null
          ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
          : null;
      final models = await remoteDataSource.getMeals(date: dateStr);
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      final start = date;
      final end = date != null ? date.add(const Duration(days: 1)) : null;
      final models = await localDataSource.getMealLogs(userId,
          startDate: start, endDate: end);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<Food>> getFoods({String? zone, String? category}) async {
    try {
      final models = await remoteDataSource.searchFoods(category: category);
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      return _getFoodsLocally(zone: zone, category: category);
    }
  }

  Future<List<Food>> searchFoods(String query, {String? category}) async {
    try {
      final models = await remoteDataSource.searchFoods(q: query, category: category);
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      return _getFoodsLocally(category: category);
    }
  }

  @override
  Future<Food?> getFood(String id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      DatabaseConstants.tableFoodItems,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _mapFood(maps.first);
  }

  @override
  Future<Map<String, double>> getDailyNutritionSummary(
      String userId, DateTime date) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return await remoteDataSource.getDailySummary(date: dateStr);
    } catch (_) {
      // Local fallback
      final meals = await getUserMeals(userId, date: date);
      double calories = 0, protein = 0, carbs = 0, fat = 0;
      for (var meal in meals) {
        final food = await getFood(meal.foodId);
        if (food != null) {
          final factor = (meal.quantity * food.standardServingSize) / 100;
          calories += food.caloriesPer100g * factor;
          protein += food.proteinPer100g * factor;
          carbs += food.carbsPer100g * factor;
          fat += food.fatPer100g * factor;
        }
      }
      return {'calories': calories, 'protein': protein, 'carbs': carbs, 'fat': fat};
    }
  }

  @override
  Future<void> syncPendingMeals() async {
    final unsynced = await localDataSource.getUnsyncedLogs();
    for (var log in unsynced) {
      try {
        await remoteDataSource.logMeal({
          'foodId': log.foodId,
          'mealPeriod': log.mealPeriod,
          'quantity': log.quantity,
          'unit': log.unit,
          'loggedAt': log.loggedAt.toIso8601String(),
        });
        await localDataSource.markAsSynced(log.id);
      } catch (_) {
        // Leave for next sync attempt
      }
    }
  }

  Future<List<Food>> _getFoodsLocally({String? zone, String? category}) async {
    final db = await dbHelper.database;
    String whereClause = '1=1';
    final whereArgs = <dynamic>[];

    if (zone != null) {
      whereClause += ' AND zone = ?';
      whereArgs.add(zone);
    }
    if (category != null) {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }

    final maps = await db.query(
      DatabaseConstants.tableFoodItems,
      where: whereClause,
      whereArgs: whereArgs,
    );
    return maps.map(_mapFood).toList();
  }

  Food _mapFood(Map<String, dynamic> map) => Food(
        id: map['id'] as String,
        nameSw: map[DatabaseConstants.columnNameSw] as String,
        nameEn: map[DatabaseConstants.columnNameEn] as String?,
        category: map[DatabaseConstants.columnCategory] as String,
        caloriesPer100g:
            (map[DatabaseConstants.columnCaloriesPer100g] as num?)?.toDouble() ?? 0.0,
        proteinPer100g:
            (map[DatabaseConstants.columnProteinPer100g] as num?)?.toDouble() ?? 0.0,
        carbsPer100g:
            (map[DatabaseConstants.columnCarbsPer100g] as num?)?.toDouble() ?? 0.0,
        fatPer100g:
            (map[DatabaseConstants.columnFatPer100g] as num?)?.toDouble() ?? 0.0,
        fiberPer100g:
            (map[DatabaseConstants.columnFiberPer100g] as num?)?.toDouble() ?? 0.0,
        standardServingSize:
            (map[DatabaseConstants.columnStandardServingSize] as num?)?.toDouble() ?? 100.0,
        servingUnit: map[DatabaseConstants.columnServingUnit] as String? ?? 'g',
        zone: map[DatabaseConstants.columnZone] as String? ?? 'all',
        isLocal: (map[DatabaseConstants.columnIsLocal] as int? ?? 1) == 1,
        imageUrl: map[DatabaseConstants.columnImageUrl] as String?,
      );
}
