import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

/// Use case for getting meals for a specific date
class GetMealsForDateUseCase {
  final MealRepository _repository;

  GetMealsForDateUseCase(this._repository);

  /// Execute the use case
  Future<List<Meal>> execute(DateTime date) async {
    // Validate input
    if (date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      throw ArgumentError('Date cannot be in the future');
    }

    // Get meals from repository
    final meals = await _repository.getMealsForDate(date);

    // Sort by category and time
    final sortedMeals = List<Meal>.from(meals);
    sortedMeals.sort((a, b) {
      // First sort by category order
      final categoryOrder = [
        MealCategory.breakfast,
        MealCategory.lunch,
        MealCategory.dinner,
        MealCategory.snack,
        MealCategory.other,
      ];
      
      final aCategoryIndex = categoryOrder.indexOf(a.category);
      final bCategoryIndex = categoryOrder.indexOf(b.category);
      
      if (aCategoryIndex != bCategoryIndex) {
        return aCategoryIndex.compareTo(bCategoryIndex);
      }
      
      // Then sort by name
      return a.name.compareTo(b.name);
    });

    return sortedMeals;
  }
}
