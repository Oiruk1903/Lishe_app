import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/food.dart';

part 'food_item_model.freezed.dart';
part 'food_item_model.g.dart';

@freezed
class FoodItemModel with _$FoodItemModel {
  const factory FoodItemModel({
    required String id,
    required String nameSw,
    String? nameEn,
    required String category,
    required double caloriesPer100g,
    required double proteinPer100g,
    required double carbsPer100g,
    required double fatPer100g,
    @Default(0.0) double fiberPer100g,
    required double standardServingSize,
    required String servingUnit,
    @Default('all') String zone,
    @Default(true) bool isLocal,
    String? imageUrl,
  }) = _FoodItemModel;

  factory FoodItemModel.fromJson(Map<String, dynamic> json) =>
      _$FoodItemModelFromJson(json);

  factory FoodItemModel.fromEntity(Food entity) => FoodItemModel(
        id: entity.id,
        nameSw: entity.nameSw,
        nameEn: entity.nameEn,
        category: entity.category,
        caloriesPer100g: entity.caloriesPer100g,
        proteinPer100g: entity.proteinPer100g,
        carbsPer100g: entity.carbsPer100g,
        fatPer100g: entity.fatPer100g,
        fiberPer100g: entity.fiberPer100g,
        standardServingSize: entity.standardServingSize,
        servingUnit: entity.servingUnit,
        zone: entity.zone,
        isLocal: entity.isLocal,
        imageUrl: entity.imageUrl,
      );
}

extension FoodItemModelX on FoodItemModel {
  Food toEntity() => Food(
        id: id,
        nameSw: nameSw,
        nameEn: nameEn,
        category: category,
        caloriesPer100g: caloriesPer100g,
        proteinPer100g: proteinPer100g,
        carbsPer100g: carbsPer100g,
        fatPer100g: fatPer100g,
        fiberPer100g: fiberPer100g,
        standardServingSize: standardServingSize,
        servingUnit: servingUnit,
        zone: zone,
        isLocal: isLocal,
        imageUrl: imageUrl,
      );
}
