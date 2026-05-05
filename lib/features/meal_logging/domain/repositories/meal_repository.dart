import '../entities/food.dart';
import '../entities/meal_entry.dart';

abstract class MealRepository {
  Future<void> logMeal(MealEntry entry);
  Future<List<MealEntry>> getUserMeals(String userId, {DateTime? date});
  Future<List<Food>> getFoods({String? zone, String? category});
  Future<Food?> getFood(String id);
  Future<Map<String, double>> getDailyNutritionSummary(
      String userId, DateTime date);
  Future<void> syncPendingMeals();
}
