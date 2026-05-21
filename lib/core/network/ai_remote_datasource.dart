import 'dart:io';
import 'package:dio/dio.dart';
import 'api_endpoints.dart';

// ─── Response models ──────────────────────────────────────────────────────────

class ChatResponse {
  final String aiResponse;
  final bool referralFlagged;
  final String? advisoryMessage;

  const ChatResponse({
    required this.aiResponse,
    required this.referralFlagged,
    this.advisoryMessage,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        aiResponse: json['ai_response'] as String? ?? '',
        referralFlagged: json['referral_flagged'] as bool? ?? false,
        advisoryMessage: json['advisory_message'] as String?,
      );
}

class ChatHistoryItem {
  final String logId;
  final String userMessage;
  final String aiResponse;
  final bool referralFlagged;
  final String createdAt;

  const ChatHistoryItem({
    required this.logId,
    required this.userMessage,
    required this.aiResponse,
    required this.referralFlagged,
    required this.createdAt,
  });

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) => ChatHistoryItem(
        logId: json['log_id'] as String? ?? '',
        userMessage: json['user_message'] as String? ?? '',
        aiResponse: json['ai_response'] as String? ?? '',
        referralFlagged: json['referral_flagged'] as bool? ?? false,
        createdAt: json['created_at'] as String? ?? '',
      );
}

class IdentifiedFood {
  final String nameEn;
  final String nameSw;
  final double confidence;
  final double estimatedGrams;

  const IdentifiedFood({
    required this.nameEn,
    required this.nameSw,
    required this.confidence,
    required this.estimatedGrams,
  });

  factory IdentifiedFood.fromJson(Map<String, dynamic> json) => IdentifiedFood(
        nameEn: json['name_en'] as String? ?? '',
        nameSw: json['name_sw'] as String? ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        estimatedGrams: (json['estimated_grams'] as num?)?.toDouble() ?? 0.0,
      );
}

class NutrientSummaryModel {
  final double totalKcal;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;

  const NutrientSummaryModel({
    required this.totalKcal,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalFiber,
  });

  factory NutrientSummaryModel.fromJson(Map<String, dynamic> json) =>
      NutrientSummaryModel(
        totalKcal: (json['total_kcal'] as num?)?.toDouble() ?? 0.0,
        totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0.0,
        totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0.0,
        totalFat: (json['total_fat'] as num?)?.toDouble() ?? 0.0,
        totalFiber: (json['total_fiber'] as num?)?.toDouble() ?? 0.0,
      );
}

class PlateAnalysisModel {
  final String analysisId;
  final List<IdentifiedFood> identifiedFoods;
  final List<String> matchedFoods;
  final List<String> unmatchedFoods;
  final NutrientSummaryModel nutrientSummary;
  final String aiExplanation;
  final String timestamp;

  const PlateAnalysisModel({
    required this.analysisId,
    required this.identifiedFoods,
    required this.matchedFoods,
    required this.unmatchedFoods,
    required this.nutrientSummary,
    required this.aiExplanation,
    required this.timestamp,
  });

  factory PlateAnalysisModel.fromJson(Map<String, dynamic> json) =>
      PlateAnalysisModel(
        analysisId: json['analysis_id'] as String? ?? '',
        identifiedFoods: (json['identified_foods'] as List<dynamic>?)
                ?.map((e) => IdentifiedFood.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        matchedFoods: (json['matched_foods'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        unmatchedFoods: (json['unmatched_foods'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        nutrientSummary: json['nutrient_summary'] != null
            ? NutrientSummaryModel.fromJson(
                json['nutrient_summary'] as Map<String, dynamic>)
            : const NutrientSummaryModel(
                totalKcal: 0,
                totalProtein: 0,
                totalCarbs: 0,
                totalFat: 0,
                totalFiber: 0),
        aiExplanation: json['ai_explanation'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
      );
}

class MealPlanFoodItem {
  final String? itemId;
  final String? foodId;
  final String? foodName;
  final String? mealType;
  final double servingSize;
  final String? notes;

  const MealPlanFoodItem({
    this.itemId,
    this.foodId,
    this.foodName,
    this.mealType,
    required this.servingSize,
    this.notes,
  });

  factory MealPlanFoodItem.fromJson(Map<String, dynamic> json) =>
      MealPlanFoodItem(
        itemId: json['item_id'] as String?,
        foodId: json['food_id'] as String?,
        foodName: json['food_name'] as String?,
        mealType: json['meal_type'] as String?,
        servingSize: (json['serving_size_g'] as num?)?.toDouble() ?? 0.0,
        notes: json['notes'] as String?,
      );
}

class MealPlanModel {
  final String? planId;
  final String? planTitle;
  final String? mealDetails;
  final String? dietarySuggestions;
  final String? generatedAt;
  final List<MealPlanFoodItem> foods;

  const MealPlanModel({
    this.planId,
    this.planTitle,
    this.mealDetails,
    this.dietarySuggestions,
    this.generatedAt,
    required this.foods,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) => MealPlanModel(
        planId: json['plan_id'] as String?,
        planTitle: json['plan_title'] as String?,
        mealDetails: json['meal_details'] as String?,
        dietarySuggestions: json['dietary_suggestions'] as String?,
        generatedAt: json['generated_at'] as String?,
        foods: (json['foods'] as List<dynamic>?)
                ?.map((e) => MealPlanFoodItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class NutritionAlertModel {
  final String? alertId;
  final String alertType;
  final String message;
  final bool isRead;
  final String? sentAt;

  const NutritionAlertModel({
    this.alertId,
    required this.alertType,
    required this.message,
    required this.isRead,
    this.sentAt,
  });

  factory NutritionAlertModel.fromJson(Map<String, dynamic> json) =>
      NutritionAlertModel(
        alertId: json['alert_id'] as String?,
        alertType: json['alert_type'] as String? ?? '',
        message: json['message'] as String? ?? '',
        isRead: json['is_read'] as bool? ?? false,
        sentAt: json['sent_at'] as String?,
      );
}

// ─── Datasource ───────────────────────────────────────────────────────────────

abstract class AiRemoteDataSource {
  Future<ChatResponse> sendChat(String message);
  Future<List<ChatHistoryItem>> getChatHistory();
  Future<PlateAnalysisModel> analyzePlate(File imageFile);
  Future<MealPlanModel?> getRecommendations();
  Future<MealPlanModel> generatePlan();
  Future<List<MealPlanModel>> getMealPlans();
  Future<List<NutritionAlertModel>> getAlerts();
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl(this.dio);

  @override
  Future<ChatResponse> sendChat(String message) async {
    final response = await dio.post(
      ApiEndpoints.chat,
      data: {'message': message},
    );
    return ChatResponse.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<ChatHistoryItem>> getChatHistory() async {
    final response = await dio.get(ApiEndpoints.chatHistory);
    final List<dynamic> items = response.data['data'] as List<dynamic>;
    return items
        .map((e) => ChatHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PlateAnalysisModel> analyzePlate(File imageFile) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });
    final response = await dio.post(
      ApiEndpoints.analyzePlate,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    return PlateAnalysisModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<MealPlanModel?> getRecommendations() async {
    final response = await dio.get(ApiEndpoints.recommendations);
    final data = response.data['data'];
    if (data == null) return null;
    return MealPlanModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<MealPlanModel> generatePlan() async {
    final response = await dio.post(ApiEndpoints.generatePlan);
    return MealPlanModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<MealPlanModel>> getMealPlans() async {
    final response = await dio.get(ApiEndpoints.mealPlans);
    final List<dynamic> items = response.data['data'] as List<dynamic>;
    return items
        .map((e) => MealPlanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<NutritionAlertModel>> getAlerts() async {
    final response = await dio.get(ApiEndpoints.alerts);
    final List<dynamic> items = response.data['data'] as List<dynamic>;
    return items
        .map((e) => NutritionAlertModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
