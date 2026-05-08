import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../services/meal_planner_service.dart';
import '../../domain/usecases/get_meals_for_date_usecase.dart';
import '../../domain/repositories/meal_repository.dart';

/// Provider for meal planner service
final mealPlannerServiceProvider = Provider<MealPlannerService>((ref) {
  return MealPlannerService(ref.read(unifiedMealServiceProvider));
});

/// Provider for meal repository
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  // This would be implemented in the data layer
  throw UnimplementedError('MealRepository implementation not yet available');
});

/// Provider for get meals for date use case
final getMealsForDateUseCaseProvider = Provider<GetMealsForDateUseCase>((ref) {
  return GetMealsForDateUseCase(ref.read(mealRepositoryProvider));
});

/// Provider for meals data for a specific date
final mealsForDateProvider =
    FutureProvider.family<List<Map<String, dynamic>>, DateTime>(
        (ref, date) async {
  final service = ref.read(mealPlannerServiceProvider);
  return await service.getMealsForDate(date);
});

/// Provider for meal statistics
final mealStatisticsProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, DateTime>>(
        (ref, dates) async {
  final startDate = dates['startDate'] as DateTime;
  final endDate = dates['endDate'] as DateTime;

  final service = ref.read(mealPlannerServiceProvider);
  return await service.getMealStatistics(startDate, endDate);
});

/// Provider for meal recommendations
final mealRecommendationsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(mealPlannerServiceProvider);
  return await service.getMealRecommendations();
});

/// Provider for selected date in meal planner
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Provider for loading state
final mealPlannerLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

/// Provider for error state
final mealPlannerErrorProvider = StateProvider<String?>((ref) {
  return null;
});

/// Combined provider for meal planner state
class MealPlannerState {
  final DateTime selectedDate;
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> meals;
  final Map<String, dynamic>? statistics;
  final List<Map<String, dynamic>> recommendations;

  const MealPlannerState({
    required this.selectedDate,
    required this.isLoading,
    this.error,
    required this.meals,
    this.statistics,
    required this.recommendations,
  });

  MealPlannerState copyWith({
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? meals,
    Map<String, dynamic>? statistics,
    List<Map<String, dynamic>>? recommendations,
  }) {
    return MealPlannerState(
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      meals: meals ?? this.meals,
      statistics: statistics ?? this.statistics,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}

final mealPlannerStateProvider =
    StateNotifierProvider<MealPlannerStateNotifier, MealPlannerState>((ref) {
  return MealPlannerStateNotifier(ref);
});

class MealPlannerStateNotifier extends StateNotifier<MealPlannerState> {
  final Ref ref;

  MealPlannerStateNotifier(this.ref)
      : super(MealPlannerState(
          selectedDate: DateTime.now(),
          isLoading: false,
          meals: [],
          recommendations: [],
        ));

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    _loadMealsForDate(date);
  }

  Future<void> _loadMealsForDate(DateTime date) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final meals = await ref.read(mealsForDateProvider(date).future);
      state = state.copyWith(
        isLoading: false,
        meals: meals,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshMeals() async {
    await _loadMealsForDate(state.selectedDate);
  }

  Future<void> addMeal(Map<String, dynamic> meal) async {
    try {
      final service = ref.read(mealPlannerServiceProvider);
      await service.addMealForDate(state.selectedDate, meal);
      await _loadMealsForDate(state.selectedDate);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleMealStatus(String mealName, bool isLogged) async {
    try {
      final service = ref.read(mealPlannerServiceProvider);
      await service.updateMealStatus(state.selectedDate, mealName,
          isLogged: isLogged);
      await _loadMealsForDate(state.selectedDate);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadStatistics(DateTime startDate, DateTime endDate) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final statistics = await ref.read(mealStatisticsProvider({
        'startDate': startDate,
        'endDate': endDate,
      }).future);

      state = state.copyWith(
        isLoading: false,
        statistics: statistics,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadRecommendations() async {
    try {
      final recommendations =
          await ref.read(mealRecommendationsProvider.future);
      state = state.copyWith(recommendations: recommendations);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
