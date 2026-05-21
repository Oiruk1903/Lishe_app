import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/ai_remote_datasource.dart';
import '../../../../core/network/api_client_provider.dart';

// ─── Provider ────────────────────────────────────────────────────────────────

final plateAiDataSourceProvider = Provider<AiRemoteDataSource>((ref) {
  return AiRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

// ─── State ────────────────────────────────────────────────────────────────────

class PlateAnalysisState {
  final PlateAnalysisModel? result;
  final bool isLoading;
  final String? errorMessage;

  const PlateAnalysisState({
    this.result,
    this.isLoading = false,
    this.errorMessage,
  });

  PlateAnalysisState copyWith({
    PlateAnalysisModel? result,
    bool? isLoading,
    String? errorMessage,
  }) =>
      PlateAnalysisState(
        result: result ?? this.result,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class PlateAnalysisNotifier extends StateNotifier<PlateAnalysisState> {
  final AiRemoteDataSource _remote;

  PlateAnalysisNotifier(this._remote) : super(const PlateAnalysisState());

  Future<void> analyzeImage(dynamic imageFile) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final file = imageFile is File ? imageFile : File(imageFile.path as String);
      final result = await _remote.analyzePlate(file);
      state = state.copyWith(result: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Imeshindwa kuchanganua picha. Tafadhali jaribu tena.',
      );
    }
  }

  void reset() => state = const PlateAnalysisState();
}

final plateAnalysisNotifierProvider =
    StateNotifierProvider<PlateAnalysisNotifier, PlateAnalysisState>((ref) {
  return PlateAnalysisNotifier(ref.watch(plateAiDataSourceProvider));
});
