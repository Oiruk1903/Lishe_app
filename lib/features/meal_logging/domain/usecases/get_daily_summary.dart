import '../repositories/meal_repository.dart';

class GetDailySummaryUseCase {
  final MealRepository repository;

  GetDailySummaryUseCase(this.repository);

  Future<Map<String, double>> call(String userId, DateTime date) {
    return repository.getDailyNutritionSummary(userId, date);
  }
}
