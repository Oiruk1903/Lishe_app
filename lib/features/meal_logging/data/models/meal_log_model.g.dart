// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealLogModelImpl _$$MealLogModelImplFromJson(Map<String, dynamic> json) =>
    _$MealLogModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      foodId: json['foodId'] as String,
      mealPeriod: json['mealPeriod'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      synced: json['synced'] as bool? ?? false,
    );

Map<String, dynamic> _$$MealLogModelImplToJson(_$MealLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'foodId': instance.foodId,
      'mealPeriod': instance.mealPeriod,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'synced': instance.synced,
    };
