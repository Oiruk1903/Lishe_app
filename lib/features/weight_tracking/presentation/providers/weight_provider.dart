import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/timeout_utils.dart';
import '../../domain/entities/weight_entry.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Providers
final weightEntriesProvider = FutureProvider<List<WeightEntry>>((ref) async {
  // Only load when user is authenticated, not during initialization
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return [];

  // Simplified: return empty list for now (no database in simplified setup)
  return await TimeoutUtils.withTimeoutAndFallbackNonNull<List<WeightEntry>>(
    Future.value([]),
    timeout: TimeoutUtils.databaseTimeout,
    fallback: [],
    operation: 'Load Weight Entries',
  );
});

final currentWeightProvider = FutureProvider<WeightEntry?>((ref) async {
  // Only load when user is authenticated
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return null;

  // Simplified: return null for now (no database in simplified setup)
  return await TimeoutUtils.withTimeoutAndFallback<WeightEntry?>(
    Future.value(null),
    timeout: TimeoutUtils.databaseTimeout,
    fallback: null,
    operation: 'Load Current Weight',
  );
});

final bmiProvider = FutureProvider<double?>((ref) async {
  // Only load when user is authenticated
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return null;

  final user = authState.user!;

  // Simplified: calculate BMI with default weight if no data available
  if (user.height == null) return null;

  final defaultWeight = 70.0; // Default weight for BMI calculation
  final bmi = defaultWeight / ((user.height! / 100) * (user.height! / 100));

  return await TimeoutUtils.withTimeoutAndFallback<double?>(
    Future.value(bmi),
    timeout: TimeoutUtils.databaseTimeout,
    fallback: null,
    operation: 'Calculate BMI',
  );
});

// Add weight state
class AddWeightState {
  final double weight;
  final String? note;
  final bool isSubmitting;
  final String? errorMessage;
  final bool success;

  const AddWeightState({
    this.weight = 70.0,
    this.note,
    this.isSubmitting = false,
    this.errorMessage,
    this.success = false,
  });

  AddWeightState copyWith({
    double? weight,
    String? note,
    bool? isSubmitting,
    String? errorMessage,
    bool? success,
  }) {
    return AddWeightState(
      weight: weight ?? this.weight,
      note: note ?? this.note,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }
}

class AddWeightNotifier extends StateNotifier<AddWeightState> {
  final Ref _ref;

  AddWeightNotifier(this._ref) : super(const AddWeightState());

  void updateWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void updateNote(String? note) {
    state = state.copyWith(note: note);
  }

  Future<bool> submit() async {
    final authState = _ref.read(authNotifierProvider);
    final userId = authState.user?.id;
    if (userId == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      // Simulate saving weight (no database in simplified setup)
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(isSubmitting: false, success: true);
      _ref.invalidate(weightEntriesProvider);
      _ref.invalidate(currentWeightProvider);
      _ref.invalidate(bmiProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const AddWeightState();
  }
}

final addWeightNotifierProvider =
    StateNotifierProvider<AddWeightNotifier, AddWeightState>((ref) {
  return AddWeightNotifier(ref);
});
