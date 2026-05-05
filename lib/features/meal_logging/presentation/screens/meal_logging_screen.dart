import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lishe_app/features/meal_logging/domain/entities/food.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/meal_entry.dart';
import '../providers/meal_provider.dart';
import '../widgets/food_search_delegate.dart';
import '../widgets/household_unit_picker.dart';
import '../widgets/meal_card.dart';

class MealLoggingScreen extends ConsumerStatefulWidget {
  const MealLoggingScreen({super.key});

  @override
  ConsumerState<MealLoggingScreen> createState() => _MealLoggingScreenState();
}

class _MealLoggingScreenState extends ConsumerState<MealLoggingScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(mealLoggingNotifierProvider);
    final notifier = ref.read(mealLoggingNotifierProvider.notifier);
    final todayMealsAsync = ref.watch(todayMealsProvider);
    final nutritionAsync = ref.watch(dailyNutritionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logMeal),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to meal history
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Summary Card
            _buildSummaryCard(context, nutritionAsync),
            SizedBox(height: 24.h),

            // Log New Meal Form
            Text(
              'Weka Mlo Mpya',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),

            // Food Selection
            _buildFoodSelector(context, state, notifier),
            SizedBox(height: 20.h),

            // Meal Period Selection
            _buildMealPeriodSelector(context, state, notifier),
            SizedBox(height: 20.h),

            // Quantity Picker (only if food selected)
            if (state.selectedFood != null) ...[
              _buildQuantityPicker(context, state, notifier),
              SizedBox(height: 24.h),
            ],

            // Submit Button
            AppButton(
              text: l10n.save,
              onPressed: state.isValid && !state.isSubmitting
                  ? () async {
                      final success = await notifier.submit();
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.success),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        notifier.reset();
                      } else if (state.errorMessage != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage!),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  : null,
              isLoading: state.isSubmitting,
            ),

            SizedBox(height: 32.h),

            // Today's Meals List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Milo ya Leo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(l10n.seeAll),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Meals List
            _buildTodayMealsList(context, todayMealsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, AsyncValue<Map<String, double>> asyncValue) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            Text(
              'Muhtasari wa Leo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16.h),
            asyncValue.when(
              loading: () => const LoadingIndicator(),
              error: (err, _) => Text('Error: $err'),
              data: (summary) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NutritionItem(
                      label: 'Kalori',
                      value:
                          '${summary['calories']?.toStringAsFixed(0) ?? '0'}',
                      unit: 'kcal',
                      color: AppColors.warning,
                    ),
                    _NutritionItem(
                      label: 'Protini',
                      value: '${summary['protein']?.toStringAsFixed(1) ?? '0'}',
                      unit: 'g',
                      color: AppColors.error,
                    ),
                    _NutritionItem(
                      label: 'Wanga',
                      value: '${summary['carbs']?.toStringAsFixed(1) ?? '0'}',
                      unit: 'g',
                      color: AppColors.carbohydrates,
                    ),
                    _NutritionItem(
                      label: 'Mafuta',
                      value: '${summary['fat']?.toStringAsFixed(1) ?? '0'}',
                      unit: 'g',
                      color: AppColors.fats,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodSelector(BuildContext context, MealLoggingState state,
      MealLoggingNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chakula',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () async {
            final selected = await showSearch<Food?>(
              context: context,
              delegate: FoodSearchDelegate(ref),
            );
            if (selected != null) {
              notifier.selectFood(selected);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingMedium,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.textSecondary),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    state.selectedFood?.nameSw ?? 'Tafuta chakula...',
                    style: TextStyle(
                      color: state.selectedFood != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
        if (state.selectedFood != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              '${state.selectedFood!.caloriesPer100g.toStringAsFixed(0)} kcal / 100g',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMealPeriodSelector(BuildContext context, MealLoggingState state,
      MealLoggingNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muda wa Mlo',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          children: MealPeriod.values.map((period) {
            final isSelected = state.selectedPeriod == period;
            String label;
            IconData icon;

            switch (period) {
              case MealPeriod.breakfast:
                label = 'Asubuhi';
                icon = Icons.wb_sunny;
                break;
              case MealPeriod.lunch:
                label = 'Mchana';
                icon = Icons.wb_sunny_outlined;
                break;
              case MealPeriod.dinner:
                label = 'Jioni';
                icon = Icons.nights_stay;
                break;
              case MealPeriod.snack:
                label = 'Kitafunio';
                icon = Icons.cookie;
                break;
            }

            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(label),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => notifier.selectPeriod(period),
              selectedColor: AppColors.primary.withOpacity(0.1),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantityPicker(BuildContext context, MealLoggingState state,
      MealLoggingNotifier notifier) {
    final food = state.selectedFood!;
    final approxGrams = state.quantity * food.standardServingSize;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kiasi (${food.servingUnit})',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        HouseholdUnitPicker(
          unit: food.servingUnit,
          value: state.quantity,
          onChanged: notifier.updateQuantity,
        ),
        SizedBox(height: 8.h),
        Text(
          '~${approxGrams.toStringAsFixed(0)} gramu',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayMealsList(
      BuildContext context, AsyncValue<List<MealEntry>> asyncValue) {
    return asyncValue.when(
      loading: () => const Center(child: LoadingIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (meals) {
        if (meals.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant_menu_outlined,
                    size: 48.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Bado hujaweka mlo wowote leo',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return MealCard(meal: meal);
          },
        );
      },
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _NutritionItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
