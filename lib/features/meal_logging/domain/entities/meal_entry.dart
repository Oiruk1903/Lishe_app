import 'package:equatable/equatable.dart';

enum MealPeriod { breakfast, lunch, dinner, snack }

class MealEntry extends Equatable {
  final String id;
  final String userId;
  final String foodId;
  final MealPeriod mealPeriod;
  final double quantity;
  final String unit;
  final DateTime loggedAt;
  final bool synced;

  const MealEntry({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.mealPeriod,
    required this.quantity,
    required this.unit,
    required this.loggedAt,
    this.synced = false,
  });

  @override
  List<Object?> get props =>
      [id, userId, foodId, mealPeriod, quantity, loggedAt];
}
