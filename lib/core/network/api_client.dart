import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/meal_logging/data/models/meal_log_model.dart';
import '../../features/weight_tracking/data/models/weight_entry_model.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // Auth Endpoints
  Future<Map<String, dynamic>> register(UserModel user, String password) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        ...user.toJson(),
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get(ApiEndpoints.profile);
    return response.data;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.put(ApiEndpoints.profile, data: data);
  }

  // Meal Endpoints
  Future<void> syncMealLogs(List<MealLogModel> logs) async {
    await _dio.post(
      ApiEndpoints.syncMeals,
      data: {
        'logs': logs.map((log) => log.toJson()).toList(),
      },
    );
  }

  Future<List<dynamic>> getFoodDatabase({String? zone}) async {
    final response = await _dio.get(
      ApiEndpoints.foods,
      queryParameters: zone != null ? {'zone': zone} : null,
    );
    return response.data;
  }

  // Weight Endpoints
  Future<void> syncWeightEntries(List<WeightEntryModel> entries) async {
    await _dio.post(
      ApiEndpoints.syncWeights,
      data: {
        'entries': entries.map((entry) => entry.toJson()).toList(),
      },
    );
  }

  // AI Chat Endpoint
  Future<String> sendChatMessage(
      String message, String userId, String cohort) async {
    final response = await _dio.post(
      ApiEndpoints.chat,
      data: {
        'message': message,
        'user_id': userId,
        'cohort': cohort,
      },
    );
    return response.data['response'];
  }

  // Plate Analysis
  Future<Map<String, dynamic>> analyzePlate(String imageBase64) async {
    final response = await _dio.post(
      ApiEndpoints.analyzePlate,
      data: {
        'image': imageBase64,
      },
    );
    return response.data;
  }
}
