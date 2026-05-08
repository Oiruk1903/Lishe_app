import '../entities/meal.dart';

/// Repository interface for meal data access
abstract class MealRepository {
  /// Get all meals for a specific date
  Future<List<Meal>> getMealsForDate(DateTime date);

  /// Add a new meal
  Future<void> addMeal(Meal meal);

  /// Update an existing meal
  Future<void> updateMeal(Meal meal);

  /// Delete a meal by ID
  Future<void> deleteMeal(String mealId);

  /// Get meals within a date range
  Future<List<Meal>> getMealsInRange(DateTime startDate, DateTime endDate);

  /// Get meal statistics for a date range
  Future<MealStatistics> getMealStatistics(DateTime startDate, DateTime endDate);

  /// Get meal recommendations
  Future<List<Meal>> getMealRecommendations();

  /// Search meals by name or tags
  Future<List<Meal>> searchMeals(String query);

  /// Get meals by category
  Future<List<Meal>> getMealsByCategory(MealCategory category);

  /// Get recently logged meals
  Future<List<Meal>> getRecentMeals({int limit = 10});

  /// Toggle meal logged status
  Future<void> toggleMealLoggedStatus(String mealId, bool isLogged);

  /// Clear cache for a specific date
  Future<void> clearCacheForDate(DateTime date);

  /// Clear all cached data
  Future<void> clearAllCache();
}
