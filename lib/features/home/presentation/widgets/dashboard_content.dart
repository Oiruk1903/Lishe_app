import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lishe_app/features/meal_logging/domain/entities/meal_entry.dart';
import 'package:lishe_app/features/meal_logging/presentation/widgets/meal_card.dart'
    show foodByIdProvider;
import 'package:lishe_app/features/weight_tracking/domain/entities/weight_entry.dart'
    show WeightEntry;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../meal_logging/presentation/providers/meal_provider.dart';
import '../../../weight_tracking/presentation/providers/weight_provider.dart';
import 'widgets/welcome_card.dart';
import 'widgets/quick_actions.dart';

class DashboardContent extends ConsumerWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authNotifierProvider.select((state) => state.user));
    final nutritionAsync = ref.watch(dailyNutritionProvider);
    final bmiAsync = ref.watch(bmiProvider);
    final weightEntriesAsync = ref.watch(weightEntriesProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          WelcomeCard(user: user),
          SizedBox(height: 20.h),

          // Quick Actions
          const QuickActions(),
          SizedBox(height: 20.h),

          // Nutrition Summary
          _buildNutritionSummary(context, nutritionAsync),
          SizedBox(height: 20.h),

          // Weight & BMI Card
          _buildWeightCard(context, bmiAsync, weightEntriesAsync),
          SizedBox(height: 20.h),

          // Food Guide
          _buildFoodGuide(context),
          SizedBox(height: 20.h),

          // Daily Tip
          _buildDailyTip(context),
          SizedBox(height: 20.h),

          // Recent Meals
          _buildRecentMeals(context, ref),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary(
      BuildContext context, AsyncValue<Map<String, double>> asyncValue) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lishe ya Leo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    context.push(Routes.mealLogging);
                  },
                  child: const Text('Ona Milo'),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            asyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (summary) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NutritionProgressItem(
                      label: 'Kalori',
                      current: summary['calories'] ?? 0,
                      target: 2000,
                      unit: 'kcal',
                      color: Colors.orange,
                    ),
                    _NutritionProgressItem(
                      label: 'Protini',
                      current: summary['protein'] ?? 0,
                      target: 50,
                      unit: 'g',
                      color: Colors.red,
                    ),
                    _NutritionProgressItem(
                      label: 'Wanga',
                      current: summary['carbs'] ?? 0,
                      target: 250,
                      unit: 'g',
                      color: Colors.green,
                    ),
                    _NutritionProgressItem(
                      label: 'Mafuta',
                      current: summary['fat'] ?? 0,
                      target: 65,
                      unit: 'g',
                      color: Colors.amber,
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

  Widget _buildWeightCard(
    BuildContext context,
    AsyncValue<double?> bmiAsync,
    AsyncValue<List<WeightEntry>> weightEntriesAsync,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Uzito na BMI',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    context.push(Routes.weightProgress);
                  },
                  child: const Text('Ona Zaidi'),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            weightEntriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (entries) {
                final currentWeight =
                    entries.isNotEmpty ? entries.last.weight : 0.0;
                final previousWeight = entries.length > 1
                    ? entries[entries.length - 2].weight
                    : null;
                final change = previousWeight != null
                    ? currentWeight - previousWeight
                    : 0.0;

                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            currentWeight > 0
                                ? '${currentWeight.toStringAsFixed(1)} kg'
                                : '-- kg',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text('Uzito wa Sasa'),
                          if (change != 0)
                            Text(
                              '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                              style: TextStyle(
                                color: change > 0
                                    ? AppColors.error
                                    : AppColors.success,
                                fontSize: 12.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: bmiAsync.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('--'),
                        data: (bmi) {
                          if (bmi == null) {
                            return const Text('Weka urefu\nkwenye wasifu');
                          }
                          final category = _getBMICategory(bmi);
                          return Column(
                            children: [
                              Text(
                                bmi.toStringAsFixed(1),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(category),
                            ],
                          );
                        },
                      ),
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

  Widget _buildFoodGuide(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mwongozo wa Chakula',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              height: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  'assets/images/lishe.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 64.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Mwongozo wa chakula\nhaujapatikana',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mwongozo wa chakula bora kulingana na vikundi vya chakula vya Tanzania',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Add fullscreen view or detailed explanation
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    size: 16.sp,
                  ),
                  label: Text(
                    'Ona Kikubwa',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTip(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kidokezo cha Siku',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Ongeza mboga za majani kama mchicha au sukuma wiki katika mlo wako kwa afya bora na kinga.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMeals(BuildContext context, WidgetRef ref) {
    final todayMealsAsync = ref.watch(todayMealsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milo ya Hivi Karibuni',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 12.h),
        todayMealsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (meals) {
            if (meals.isEmpty) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu_outlined,
                        size: 40.sp,
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
              itemCount: meals.length > 3 ? 3 : meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return _RecentMealItem(meal: meal);
              },
            );
          },
        ),
      ],
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Upungufu';
    if (bmi < 25) return 'Kawaida';
    if (bmi < 30) return 'Kupita Kiasi';
    return 'Unene';
  }
}

class _NutritionProgressItem extends StatelessWidget {
  final String label;
  final double current;
  final double target;
  final String unit;
  final Color color;

  const _NutritionProgressItem({
    required this.label,
    required this.current,
    required this.target,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / target;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50.w,
              height: 50.w,
              child: CircularProgressIndicator(
                value: progress > 1 ? 1 : progress,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 4,
              ),
            ),
            Text(
              current.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 9.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _RecentMealItem extends ConsumerWidget {
  final MealEntry meal;

  const _RecentMealItem({required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodAsync = ref.watch(foodByIdProvider(meal.foodId));

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getPeriodColor(meal.mealPeriod).withOpacity(0.1),
        child: Icon(
          _getPeriodIcon(meal.mealPeriod),
          color: _getPeriodColor(meal.mealPeriod),
          size: 18.sp,
        ),
      ),
      title: foodAsync.when(
        loading: () => const Text('Loading...'),
        error: (_, __) => const Text('Error'),
        data: (food) => Text(food?.nameSw ?? 'Unknown'),
      ),
      subtitle: Text('${meal.quantity} ${meal.unit}'),
      trailing: Text(
        '${meal.loggedAt.hour}:${meal.loggedAt.minute.toString().padLeft(2, '0')}',
        style: TextStyle(color: AppColors.textSecondary),
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
}

extension on Object? {
  get nameSw => null;
}
