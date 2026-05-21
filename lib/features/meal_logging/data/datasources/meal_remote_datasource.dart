import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/food_item_model.dart';
import '../models/meal_log_model.dart';

abstract class MealRemoteDataSource {
  Future<List<FoodItemModel>> searchFoods({String? q, String? category});
  Future<MealLogModel> logMeal(Map<String, dynamic> data);
  Future<List<MealLogModel>> getMeals({String? date});
  Future<MealLogModel> updateMeal(String id, Map<String, dynamic> data);
  Future<void> deleteMeal(String id);
  Future<Map<String, double>> getDailySummary({String? date});
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final Dio dio;

  MealRemoteDataSourceImpl(this.dio);

  @override
  Future<List<FoodItemModel>> searchFoods({String? q, String? category}) async {
    final params = <String, dynamic>{};
    if (q != null && q.isNotEmpty) params['q'] = q;
    if (category != null && category.isNotEmpty) params['category'] = category;

    final response = await dio.get(ApiEndpoints.foods, queryParameters: params);
    final List<dynamic> items = response.data['data'] as List<dynamic>;
    return items
        .map((json) => FoodItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MealLogModel> logMeal(Map<String, dynamic> data) async {
    final response = await dio.post(ApiEndpoints.meals, data: data);
    return MealLogModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<MealLogModel>> getMeals({String? date}) async {
    final params = date != null ? {'date': date} : null;
    final response = await dio.get(ApiEndpoints.meals, queryParameters: params);
    final List<dynamic> items = response.data['data'] as List<dynamic>;
    return items
        .map((json) => MealLogModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MealLogModel> updateMeal(String id, Map<String, dynamic> data) async {
    final response = await dio.put('${ApiEndpoints.meals}/$id', data: data);
    return MealLogModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteMeal(String id) async {
    await dio.delete('${ApiEndpoints.meals}/$id');
  }

  @override
  Future<Map<String, double>> getDailySummary({String? date}) async {
    final params = date != null ? {'date': date} : null;
    final response =
        await dio.get(ApiEndpoints.mealsSummary, queryParameters: params);
    final data = response.data['data'] as Map<String, dynamic>;
    return {
      'calories': (data['calories'] as num?)?.toDouble() ?? 0.0,
      'protein': (data['protein'] as num?)?.toDouble() ?? 0.0,
      'carbs': (data['carbs'] as num?)?.toDouble() ?? 0.0,
      'fat': (data['fat'] as num?)?.toDouble() ?? 0.0,
      'fiber': (data['fiber'] as num?)?.toDouble() ?? 0.0,
    };
  }
}
