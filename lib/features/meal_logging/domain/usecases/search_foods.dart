import '../repositories/meal_repository.dart';
import '../entities/food.dart';

class SearchFoodsUseCase {
  final MealRepository repository;

  SearchFoodsUseCase(this.repository);

  Future<List<Food>> call(String query, {String? zone}) async {
    final foods = await repository.getFoods(zone: zone);
    final lowerQuery = query.toLowerCase();
    return foods.where((food) {
      return food.nameSw.toLowerCase().contains(lowerQuery) ||
          (food.nameEn?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
