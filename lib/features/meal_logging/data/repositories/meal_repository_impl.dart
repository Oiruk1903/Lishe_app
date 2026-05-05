import '../../domain/repositories/meal_repository.dart';
import '../../domain/entities/meal_entry.dart';
import '../../domain/entities/food.dart';
import '../datasources/meal_local_datasource.dart';
import '../models/meal_log_model.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_constants.dart';

class MealRepositoryImpl implements MealRepository {
  final MealLocalDataSource localDataSource;
  final DatabaseHelper dbHelper;

  MealRepositoryImpl(this.localDataSource, this.dbHelper);

  @override
  Future<void> logMeal(MealEntry entry) async {
    final model = MealLogModel.fromEntity(entry);
    await localDataSource.saveMealLog(model);
  }

  @override
  Future<List<MealEntry>> getUserMeals(String userId, {DateTime? date}) async {
    DateTime? startDate = date;
    DateTime? endDate = date != null ? date.add(const Duration(days: 1)) : null;
    final models = await localDataSource.getMealLogs(userId,
        startDate: startDate, endDate: endDate);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Food>> getFoods({String? zone, String? category}) async {
    final db = await dbHelper.database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (zone != null) {
      whereClause += ' AND zone = ?';
      whereArgs.add(zone);
    }

    if (category != null) {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableFoodItems,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return maps
        .map((map) => Food(
              id: map['id'] as String,
              nameSw: map[DatabaseConstants.columnNameSw] as String,
              nameEn: map[DatabaseConstants.columnNameEn] as String?,
              category: map[DatabaseConstants.columnCategory] as String,
              caloriesPer100g:
                  (map[DatabaseConstants.columnCaloriesPer100g] as num?)
                          ?.toDouble() ??
                      0.0,
              proteinPer100g:
                  (map[DatabaseConstants.columnProteinPer100g] as num?)
                          ?.toDouble() ??
                      0.0,
              carbsPer100g: (map[DatabaseConstants.columnCarbsPer100g] as num?)
                      ?.toDouble() ??
                  0.0,
              fatPer100g: (map[DatabaseConstants.columnFatPer100g] as num?)
                      ?.toDouble() ??
                  0.0,
              fiberPer100g: (map[DatabaseConstants.columnFiberPer100g] as num?)
                      ?.toDouble() ??
                  0.0,
              standardServingSize:
                  (map[DatabaseConstants.columnStandardServingSize] as num?)
                          ?.toDouble() ??
                      100.0,
              servingUnit:
                  map[DatabaseConstants.columnServingUnit] as String? ?? 'g',
              zone: map[DatabaseConstants.columnZone] as String? ?? 'all',
              isLocal: (map[DatabaseConstants.columnIsLocal] as int) == 1,
              imageUrl: map[DatabaseConstants.columnImageUrl] as String?,
            ))
        .toList();
  }

  @override
  Future<Food?> getFood(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableFoodItems,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    final map = maps.first;
    return Food(
      id: map['id'] as String,
      nameSw: map[DatabaseConstants.columnNameSw] as String,
      nameEn: map[DatabaseConstants.columnNameEn] as String?,
      category: map[DatabaseConstants.columnCategory] as String,
      caloriesPer100g:
          (map[DatabaseConstants.columnCaloriesPer100g] as num?)?.toDouble() ??
              0.0,
      proteinPer100g:
          (map[DatabaseConstants.columnProteinPer100g] as num?)?.toDouble() ??
              0.0,
      carbsPer100g:
          (map[DatabaseConstants.columnCarbsPer100g] as num?)?.toDouble() ??
              0.0,
      fatPer100g:
          (map[DatabaseConstants.columnFatPer100g] as num?)?.toDouble() ?? 0.0,
      fiberPer100g:
          (map[DatabaseConstants.columnFiberPer100g] as num?)?.toDouble() ??
              0.0,
      standardServingSize:
          (map[DatabaseConstants.columnStandardServingSize] as num?)
                  ?.toDouble() ??
              100.0,
      servingUnit: map[DatabaseConstants.columnServingUnit] as String? ?? 'g',
      zone: map[DatabaseConstants.columnZone] as String? ?? 'all',
      isLocal: (map[DatabaseConstants.columnIsLocal] as int) == 1,
      imageUrl: map[DatabaseConstants.columnImageUrl] as String?,
    );
  }

  @override
  Future<Map<String, double>> getDailyNutritionSummary(
      String userId, DateTime date) async {
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

    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  @override
  Future<void> syncPendingMeals() async {
    final unsynced = await localDataSource.getUnsyncedLogs();
    // TODO: Implement API sync
    for (var log in unsynced) {
      await localDataSource.markAsSynced(log.id);
    }
  }
}
