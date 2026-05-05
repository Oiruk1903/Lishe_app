import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/tflite_service.dart';
import '../../data/models/plate_analysis_result.dart';

final tfliteServiceProvider = Provider<TFLiteService>((ref) {
  return TFLiteService();
});

class PlateAnalysisState {
  final PlateAnalysisResult? result;
  final bool isLoading;
  final String? errorMessage;

  const PlateAnalysisState({
    this.result,
    this.isLoading = false,
    this.errorMessage,
  });

  PlateAnalysisState copyWith({
    PlateAnalysisResult? result,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlateAnalysisState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class PlateAnalysisNotifier extends StateNotifier<PlateAnalysisState> {
  final TFLiteService _tfliteService;

  PlateAnalysisNotifier(this._tfliteService)
      : super(const PlateAnalysisState());

  Future<void> analyzeImage(dynamic imageFile) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _tfliteService.analyzeImage(imageFile);
      state = state.copyWith(result: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Imeshindwa kuchanganua picha. Tafadhali jaribu tena.',
      );
    }
  }

  void reset() {
    state = const PlateAnalysisState();
  }
}

final plateAnalysisNotifierProvider =
    StateNotifierProvider<PlateAnalysisNotifier, PlateAnalysisState>((ref) {
  final service = ref.watch(tfliteServiceProvider);
  return PlateAnalysisNotifier(service);
});
