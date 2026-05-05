import 'package:equatable/equatable.dart';

class Food extends Equatable {
  final String id;
  final String nameSw;
  final String? nameEn;
  final String category;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double fiberPer100g;
  final double standardServingSize;
  final String servingUnit;
  final String zone;
  final bool isLocal;
  final String? imageUrl;

  const Food({
    required this.id,
    required this.nameSw,
    this.nameEn,
    required this.category,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.fiberPer100g,
    required this.standardServingSize,
    required this.servingUnit,
    required this.zone,
    required this.isLocal,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, nameSw, category];
}
