import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/timeout_utils.dart';
import '../../../../core/utils/cache_utils.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/meal_entry.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/food_data.dart';

// Providers for data with caching
final foodItemsProvider =
    FutureProvider.family<List<Food>, String?>((ref, zone) async {
  final cacheKey = 'food_items_${zone ?? 'all'}';

  final result = await ProviderCache.getOrFetch<List<Food>>(
    cacheKey,
    () async {
      return await TimeoutUtils.withTimeoutAndFallbackNonNull<List<Food>>(
        Future.value(FoodData.getAllFoods()),
        timeout: TimeoutUtils.databaseTimeout,
        fallback: [],
        operation: 'Load Food Items',
      );
    },
    ttl: ProviderCache.longTtl,
  );
  return result ?? [];
});

final todayMealsProvider = FutureProvider<List<MealEntry>>((ref) async {
  // Only load when user is authenticated, not during initialization
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return [];

  final user = authState.user!;
  final cacheKey =
      'meals_${user.id}_${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}';

  final result = await ProviderCache.getOrFetch<List<MealEntry>>(
    cacheKey,
    () async {
      // Simplified: return empty list for now (no database in simplified setup)
      return await TimeoutUtils.withTimeoutAndFallbackNonNull<List<MealEntry>>(
        Future.value([]),
        timeout: TimeoutUtils.databaseTimeout,
        fallback: [],
        operation: 'Load Today Meals',
      );
    },
    ttl: ProviderCache.shortTtl,
  );
  return result ?? [];
});

final dailyNutritionProvider = FutureProvider<Map<String, double>>((ref) async {
  // Only calculate when user is authenticated
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null)
    return {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0};

  final user = authState.user!;
  final cacheKey =
      'nutrition_${user.id}_${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}';

  final result = await ProviderCache.getOrFetch<Map<String, double>>(
    cacheKey,
    () async {
      // Simplified: return default nutrition values (no database in simplified setup)
      return await TimeoutUtils.withTimeoutAndFallbackNonNull<
          Map<String, double>>(
        Future.value({'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0}),
        timeout: TimeoutUtils.databaseTimeout,
        fallback: {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0},
        operation: 'Calculate Daily Nutrition',
      );
    },
    ttl: ProviderCache.shortTtl,
  );
  return result ?? {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0};
});

// State for meal logging form
class MealLoggingState {
  final Food? selectedFood;
  final MealPeriod? selectedPeriod;
  final double quantity;
  final bool isSubmitting;
  final String? errorMessage;
  final bool success;

  const MealLoggingState({
    this.selectedFood,
    this.selectedPeriod,
    this.quantity = 1.0,
    this.isSubmitting = false,
    this.errorMessage,
    this.success = false,
  });

  MealLoggingState copyWith({
    Food? selectedFood,
    MealPeriod? selectedPeriod,
    double? quantity,
    bool? isSubmitting,
    String? errorMessage,
    bool? success,
  }) {
    return MealLoggingState(
      selectedFood: selectedFood ?? this.selectedFood,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      quantity: quantity ?? this.quantity,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }

  bool get isValid => selectedFood != null && selectedPeriod != null;
}

class MealLoggingNotifier extends StateNotifier<MealLoggingState> {
  final Ref _ref;

  MealLoggingNotifier(this._ref) : super(const MealLoggingState());

  void selectFood(Food food) {
    state = state.copyWith(selectedFood: food);
  }

  void selectPeriod(MealPeriod period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void updateQuantity(double quantity) {
    state = state.copyWith(quantity: quantity);
  }

  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 0.5);
  }

  void decrementQuantity() {
    if (state.quantity > 0.5) {
      state = state.copyWith(quantity: state.quantity - 0.5);
    }
  }

  void reset() {
    state = const MealLoggingState();
  }

  Future<bool> submit() async {
    final authState = _ref.read(authNotifierProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return false;
    }

    if (!state.isValid) {
      state = state.copyWith(
          errorMessage: 'Tafadhali chagua chakula na muda wa mlo');
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      // Simulate saving meal (no database in simplified setup)
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(isSubmitting: false, success: true);

      // Invalidate cache and providers to refresh data
      final today = DateTime.now();
      final cacheKeyToday =
          'meals_${userId}_${today.year}_${today.month}_${today.day}';
      final cacheKeyNutrition =
          'nutrition_${userId}_${today.year}_${today.month}_${today.day}';

      CacheUtils.invalidate(cacheKeyToday);
      CacheUtils.invalidate(cacheKeyNutrition);
      _ref.invalidate(todayMealsProvider);
      _ref.invalidate(dailyNutritionProvider);

      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Imeshindwa kuhifadhi mlo: $e',
      );
      return false;
    }
  }
}

final mealLoggingNotifierProvider =
    StateNotifierProvider<MealLoggingNotifier, MealLoggingState>((ref) {
  return MealLoggingNotifier(ref);
});
