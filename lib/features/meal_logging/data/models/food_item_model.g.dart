// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodItemModelImpl _$$FoodItemModelImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemModelImpl(
      id: json['id'] as String,
      nameSw: json['nameSw'] as String,
      nameEn: json['nameEn'] as String?,
      category: json['category'] as String,
      caloriesPer100g: (json['caloriesPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num).toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num).toDouble(),
      fatPer100g: (json['fatPer100g'] as num).toDouble(),
      fiberPer100g: (json['fiberPer100g'] as num?)?.toDouble() ?? 0.0,
      standardServingSize: (json['standardServingSize'] as num).toDouble(),
      servingUnit: json['servingUnit'] as String,
      zone: json['zone'] as String? ?? 'all',
      isLocal: json['isLocal'] as bool? ?? true,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$FoodItemModelImplToJson(_$FoodItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameSw': instance.nameSw,
      'nameEn': instance.nameEn,
      'category': instance.category,
      'caloriesPer100g': instance.caloriesPer100g,
      'proteinPer100g': instance.proteinPer100g,
      'carbsPer100g': instance.carbsPer100g,
      'fatPer100g': instance.fatPer100g,
      'fiberPer100g': instance.fiberPer100g,
      'standardServingSize': instance.standardServingSize,
      'servingUnit': instance.servingUnit,
      'zone': instance.zone,
      'isLocal': instance.isLocal,
      'imageUrl': instance.imageUrl,
    };
