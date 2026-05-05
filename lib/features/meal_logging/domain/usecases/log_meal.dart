import 'package:uuid/uuid.dart';
import '../repositories/meal_repository.dart';
import '../entities/meal_entry.dart';

class LogMealUseCase {
  final MealRepository repository;

  LogMealUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String foodId,
    required MealPeriod mealPeriod,
    required double quantity,
    required String unit,
  }) async {
    final entry = MealEntry(
      id: const Uuid().v4(),
      userId: userId,
      foodId: foodId,
      mealPeriod: mealPeriod,
      quantity: quantity,
      unit: unit,
      loggedAt: DateTime.now(),
    );
    await repository.logMeal(entry);
  }
}
