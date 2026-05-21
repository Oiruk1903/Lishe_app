import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/ai_remote_datasource.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../../../core/utils/timeout_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ─── Provider ────────────────────────────────────────────────────────────────

final recommendationDataSourceProvider = Provider<AiRemoteDataSource>((ref) {
  return AiRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

// ─── Read providers ───────────────────────────────────────────────────────────

final currentRecommendationProvider = FutureProvider<MealPlanModel?>((ref) async {
  final auth = ref.watch(authNotifierProvider);
  if (auth.isLoading || auth.user == null) return null;

  final remote = ref.read(recommendationDataSourceProvider);
  return TimeoutUtils.withTimeoutAndFallback<MealPlanModel?>(
    remote.getRecommendations(),
    timeout: const Duration(seconds: 15),
    fallback: null,
    operation: 'Load Recommendations',
  );
});

final mealPlansProvider = FutureProvider<List<MealPlanModel>>((ref) async {
  final auth = ref.watch(authNotifierProvider);
  if (auth.isLoading || auth.user == null) return [];

  final remote = ref.read(recommendationDataSourceProvider);
  return TimeoutUtils.withTimeoutAndFallbackNonNull<List<MealPlanModel>>(
    remote.getMealPlans(),
    timeout: const Duration(seconds: 15),
    fallback: [],
    operation: 'Load Meal Plans',
  );
});

final nutritionAlertsProvider = FutureProvider<List<NutritionAlertModel>>((ref) async {
  final auth = ref.watch(authNotifierProvider);
  if (auth.isLoading || auth.user == null) return [];

  final remote = ref.read(recommendationDataSourceProvider);
  return TimeoutUtils.withTimeoutAndFallbackNonNull<List<NutritionAlertModel>>(
    remote.getAlerts(),
    timeout: const Duration(seconds: 10),
    fallback: [],
    operation: 'Load Nutrition Alerts',
  );
});

// ─── Generate plan notifier ───────────────────────────────────────────────────

class GeneratePlanState {
  final MealPlanModel? plan;
  final bool isGenerating;
  final String? errorMessage;
  final bool success;

  const GeneratePlanState({
    this.plan,
    this.isGenerating = false,
    this.errorMessage,
    this.success = false,
  });

  GeneratePlanState copyWith({
    MealPlanModel? plan,
    bool? isGenerating,
    String? errorMessage,
    bool? success,
  }) =>
      GeneratePlanState(
        plan: plan ?? this.plan,
        isGenerating: isGenerating ?? this.isGenerating,
        errorMessage: errorMessage,
        success: success ?? this.success,
      );
}

class GeneratePlanNotifier extends StateNotifier<GeneratePlanState> {
  final Ref _ref;

  GeneratePlanNotifier(this._ref) : super(const GeneratePlanState());

  Future<void> generate() async {
    final auth = _ref.read(authNotifierProvider);
    if (auth.user == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return;
    }

    state = state.copyWith(isGenerating: true, errorMessage: null, success: false);

    try {
      final remote = _ref.read(recommendationDataSourceProvider);
      final plan = await remote.generatePlan();
      state = state.copyWith(plan: plan, isGenerating: false, success: true);
      _ref.invalidate(currentRecommendationProvider);
      _ref.invalidate(mealPlansProvider);
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Imeshindwa kutengeneza mpango. Tafadhali jaribu tena.',
      );
    }
  }

  void reset() => state = const GeneratePlanState();
}

final generatePlanNotifierProvider =
    StateNotifierProvider<GeneratePlanNotifier, GeneratePlanState>((ref) {
  return GeneratePlanNotifier(ref);
});
