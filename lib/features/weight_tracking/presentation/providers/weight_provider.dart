import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/timeout_utils.dart';
import '../../data/datasources/weight_remote_datasource.dart';
import '../../data/models/bmi_model.dart';
import '../../data/repositories/weight_repository_impl.dart';
import '../../domain/entities/weight_entry.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ─── Infrastructure providers ─────────────────────────────────────────────────

final weightRemoteDataSourceProvider = Provider<WeightRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return WeightRemoteDataSourceImpl(dio);
});

final weightRepositoryProvider = Provider<WeightRepositoryImpl>((ref) {
  final remote = ref.watch(weightRemoteDataSourceProvider);
  // WeightLocalDataSource is assumed to be provided or use a default impl.
  // If a localDataSourceProvider exists, wire it here. For now use a no-op stub
  // backed by the local datasource provider when available.
  final local = ref.watch(weightLocalDataSourceProvider);
  return WeightRepositoryImpl(local, remote);
});

// ─── Data providers ───────────────────────────────────────────────────────────

final weightEntriesProvider = FutureProvider<List<WeightEntry>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return [];

  final repo = ref.read(weightRepositoryProvider);
  return TimeoutUtils.withTimeoutAndFallbackNonNull<List<WeightEntry>>(
    repo.getWeightHistory(authState.user!.id, days: 30),
    timeout: const Duration(seconds: 15),
    fallback: [],
    operation: 'Load Weight History',
  );
});

final currentWeightProvider = FutureProvider<WeightEntry?>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return null;

  final repo = ref.read(weightRepositoryProvider);
  return TimeoutUtils.withTimeoutAndFallback<WeightEntry?>(
    repo.getCurrentWeight(authState.user!.id),
    timeout: const Duration(seconds: 10),
    fallback: null,
    operation: 'Load Current Weight',
  );
});

final bmiProvider = FutureProvider<BmiModel?>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return null;

  final repo = ref.read(weightRepositoryProvider);
  return TimeoutUtils.withTimeoutAndFallback<BmiModel?>(
    repo.getBmi(),
    timeout: const Duration(seconds: 10),
    fallback: null,
    operation: 'Load BMI',
  );
});

final weightTrendsProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, days) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading || authState.user == null) return {};

  final repo = ref.read(weightRepositoryProvider);
  return TimeoutUtils.withTimeoutAndFallbackNonNull<Map<String, dynamic>>(
    repo.getTrends(days: days),
    timeout: const Duration(seconds: 10),
    fallback: {},
    operation: 'Load Weight Trends',
  );
});

// ─── Add weight state / notifier ─────────────────────────────────────────────

class AddWeightState {
  final double weight;
  final double? heightCm;
  final String? note;
  final bool isSubmitting;
  final String? errorMessage;
  final bool success;

  const AddWeightState({
    this.weight = 70.0,
    this.heightCm,
    this.note,
    this.isSubmitting = false,
    this.errorMessage,
    this.success = false,
  });

  AddWeightState copyWith({
    double? weight,
    double? heightCm,
    String? note,
    bool? isSubmitting,
    String? errorMessage,
    bool? success,
  }) {
    return AddWeightState(
      weight: weight ?? this.weight,
      heightCm: heightCm ?? this.heightCm,
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

  void updateWeight(double weight) => state = state.copyWith(weight: weight);
  void updateHeight(double? heightCm) => state = state.copyWith(heightCm: heightCm);
  void updateNote(String? note) => state = state.copyWith(note: note);

  Future<bool> submit() async {
    final authState = _ref.read(authNotifierProvider);
    final userId = authState.user?.id;
    if (userId == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final repo = _ref.read(weightRepositoryProvider);
      await repo.addWeightEntry(
        userId: userId,
        weight: state.weight,
        heightCm: state.heightCm,
        note: state.note,
      );
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

  void reset() => state = const AddWeightState();
}

final addWeightNotifierProvider =
    StateNotifierProvider<AddWeightNotifier, AddWeightState>((ref) {
  return AddWeightNotifier(ref);
});
