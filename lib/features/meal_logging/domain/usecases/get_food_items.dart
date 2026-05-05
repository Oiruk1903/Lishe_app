import '../repositories/meal_repository.dart';
import '../entities/food.dart';

class GetFoodItemsUseCase {
  final MealRepository repository;

  GetFoodItemsUseCase(this.repository);

  Future<List<Food>> call({String? zone, String? category}) {
    return repository.getFoods(zone: zone, category: category);
  }
}
