import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lishe_app/core/constants/app_dimensions.dart';
import 'package:lishe_app/features/meal_logging/domain/entities/food.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/meal_entry.dart';
import '../../data/food_data.dart';

class MealCard extends ConsumerWidget {
  final MealEntry meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodAsync = ref.watch(foodByIdProvider(meal.foodId));

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: foodAsync.when(
          loading: () => const ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Loading...'),
          ),
          error: (err, _) => ListTile(
            leading: const Icon(Icons.error),
            title: Text('Error loading food'),
          ),
          data: (food) {
            if (food == null) {
              return const ListTile(title: Text('Food not found'));
            }

            final calories = (meal.quantity * food.standardServingSize / 100) *
                food.caloriesPer100g;

            return Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: _getPeriodColor(meal.mealPeriod).withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Icon(
                    _getPeriodIcon(meal.mealPeriod),
                    color: _getPeriodColor(meal.mealPeriod),
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.nameSw,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '${meal.quantity} ${meal.unit} · ${calories.toStringAsFixed(0)} kcal',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatTime(meal.loggedAt),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  IconData _getPeriodIcon(MealPeriod period) {
    switch (period) {
      case MealPeriod.breakfast:
        return Icons.wb_sunny;
      case MealPeriod.lunch:
        return Icons.wb_sunny_outlined;
      case MealPeriod.dinner:
        return Icons.nights_stay;
      case MealPeriod.snack:
        return Icons.cookie;
    }
  }

  Color _getPeriodColor(MealPeriod period) {
    switch (period) {
      case MealPeriod.breakfast:
        return Colors.orange;
      case MealPeriod.lunch:
        return AppColors.primary;
      case MealPeriod.dinner:
        return Colors.indigo;
      case MealPeriod.snack:
        return Colors.purple;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

extension on Object {}

// Additional provider for fetching single food item
final foodByIdProvider =
    FutureProvider.family<Food?, String>((ref, foodId) async {
  // Use FoodData directly - no complex repository needed
  final foods = FoodData.getAllFoods();
  try {
    return foods.firstWhere((food) => food.id == foodId);
  } catch (e) {
    return null;
  }
});
