import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/meal_entry.dart';

part 'meal_log_model.freezed.dart';
part 'meal_log_model.g.dart';

@freezed
class MealLogModel with _$MealLogModel {
  const factory MealLogModel({
    required String id,
    required String userId,
    required String foodId,
    required String mealPeriod,
    required double quantity,
    required String unit,
    required DateTime loggedAt,
    @Default(false) bool synced,
  }) = _MealLogModel;

  factory MealLogModel.fromJson(Map<String, dynamic> json) =>
      _$MealLogModelFromJson(json);

  factory MealLogModel.fromEntity(MealEntry entry) => MealLogModel(
        id: entry.id,
        userId: entry.userId,
        foodId: entry.foodId,
        mealPeriod: entry.mealPeriod.name,
        quantity: entry.quantity,
        unit: entry.unit,
        loggedAt: entry.loggedAt,
        synced: entry.synced,
      );
}

extension MealLogModelX on MealLogModel {
  MealEntry toEntity() => MealEntry(
        id: id,
        userId: userId,
        foodId: foodId,
        mealPeriod: MealPeriod.values.firstWhere((e) => e.name == mealPeriod),
        quantity: quantity,
        unit: unit,
        loggedAt: loggedAt,
        synced: synced,
      );
}
