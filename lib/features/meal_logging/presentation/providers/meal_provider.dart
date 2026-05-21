import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/timeout_utils.dart';
import '../../../../core/utils/cache_utils.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/meal_remote_datasource.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/meal_entry.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ─── Remote datasource provider ─────────────────────────────────────────────

final mealRemoteDataSourceProvider = Provider<MealRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return MealRemoteDataSourceImpl(dio);
});

// ─── Food search ─────────────────────────────────────────────────────────────

final foodItemsProvider =
    FutureProvider.family<List<Food>, String?>((ref, zone) async {
  final remote = ref.read(mealRemoteDataSourceProvider);
  final cacheKey = 'food_items_${zone ?? 'all'}';

  final result = await ProviderCache.getOrFetch<List<Food>>(
    cacheKey,
    () async => TimeoutUtils.withTimeoutAndFallbackNonNull<List<Food>>(
      remote.searchFoods().then((models) => models.map((m) => m.toEntity()).toList()),
      timeout: const Duration(seconds: 15),
      fallback: [],
      operation: 'Load Food Items',
    ),
    ttl: ProviderCache.longTtl,
  );
  return result ?? [];
});

final foodSearchProvider =
    FutureProvider.family<List<Food>, String>((ref, query) async {
  final remote = ref.read(mealRemoteDataSourceProvider);
  try {
    final models = await remote.searchFoods(q: query);
    return models.map((m) => m.toEntity()).toList();
  } catch (_) {
    return [];
  }
});

// ─── Today's meals ───────────────────────────────────────────────────────────

final todayMealsProvider = FutureProvider<List<MealEntry>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return [];

  final user = authState.user!;
  final now = DateTime.now();
  final cacheKey = 'meals_${user.id}_${now.year}_${now.month}_${now.day}';
  final remote = ref.read(mealRemoteDataSourceProvider);

  final result = await ProviderCache.getOrFetch<List<MealEntry>>(
    cacheKey,
    () async => TimeoutUtils.withTimeoutAndFallbackNonNull<List<MealEntry>>(
      remote.getMeals().then((models) => models.map((m) => m.toEntity()).toList()),
      timeout: const Duration(seconds: 15),
      fallback: [],
      operation: 'Load Today Meals',
    ),
    ttl: ProviderCache.shortTtl,
  );
  return result ?? [];
});

// ─── Daily nutrition summary ─────────────────────────────────────────────────

final dailyNutritionProvider = FutureProvider<Map<String, double>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) {
    return {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0};
  }

  final user = authState.user!;
  final now = DateTime.now();
  final cacheKey =
      'nutrition_${user.id}_${now.year}_${now.month}_${now.day}';
  final remote = ref.read(mealRemoteDataSourceProvider);

  final result = await ProviderCache.getOrFetch<Map<String, double>>(
    cacheKey,
    () async => TimeoutUtils.withTimeoutAndFallbackNonNull<Map<String, double>>(
      remote.getDailySummary(),
      timeout: const Duration(seconds: 15),
      fallback: {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0},
      operation: 'Daily Nutrition Summary',
    ),
    ttl: ProviderCache.shortTtl,
  );
  return result ?? {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0};
});

// ─── Meal logging form state ──────────────────────────────────────────────────

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

  void selectFood(Food food) => state = state.copyWith(selectedFood: food);
  void selectPeriod(MealPeriod period) => state = state.copyWith(selectedPeriod: period);
  void updateQuantity(double quantity) => state = state.copyWith(quantity: quantity);

  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 0.5);
  }

  void decrementQuantity() {
    if (state.quantity > 0.5) {
      state = state.copyWith(quantity: state.quantity - 0.5);
    }
  }

  void reset() => state = const MealLoggingState();

  Future<bool> submit() async {
    final authState = _ref.read(authNotifierProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      state = state.copyWith(errorMessage: 'Mtumiaji hajaingiza');
      return false;
    }
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Tafadhali chagua chakula na muda wa mlo');
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final remote = _ref.read(mealRemoteDataSourceProvider);
      await remote.logMeal({
        'foodId': state.selectedFood!.id,
        'mealPeriod': state.selectedPeriod!.name,
        'quantity': state.quantity * (state.selectedFood!.standardServingSize),
        'unit': state.selectedFood!.servingUnit,
        'loggedAt': DateTime.now().toIso8601String(),
      });

      state = state.copyWith(isSubmitting: false, success: true);

      // Bust cache so UI refreshes
      final today = DateTime.now();
      CacheUtils.invalidate('meals_${userId}_${today.year}_${today.month}_${today.day}');
      CacheUtils.invalidate('nutrition_${userId}_${today.year}_${today.month}_${today.day}');
      _ref.invalidate(todayMealsProvider);
      _ref.invalidate(dailyNutritionProvider);

      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Imeshindwa kuhifadhi mlo: ${_friendlyError(e)}',
      );
      return false;
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('connection') || msg.contains('network')) {
      return 'Hakuna mtandao';
    }
    if (msg.contains('401') || msg.contains('unauthorised')) {
      return 'Tafadhali ingia tena';
    }
    return 'Hitilafu imetokea';
  }
}

final mealLoggingNotifierProvider =
    StateNotifierProvider<MealLoggingNotifier, MealLoggingState>((ref) {
  return MealLoggingNotifier(ref);
});
