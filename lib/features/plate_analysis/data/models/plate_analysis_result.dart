import 'package:equatable/equatable.dart';

class PlateAnalysisResult extends Equatable {
  final Map<String, double> predictions;
  final List<String> recommendations;
  final DateTime timestamp;

  const PlateAnalysisResult({
    required this.predictions,
    required this.recommendations,
    required this.timestamp,
  });

  String get predominantFoodGroup {
    return predictions.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  bool get isBalanced {
    final carbs = predictions['Wanga'] ?? 0;
    final protein = predictions['Protini'] ?? 0;
    final veggies = predictions['Mboga'] ?? 0;
    return carbs > 0.2 && protein > 0.15 && veggies > 0.15;
  }

  @override
  List<Object?> get props => [predictions, recommendations, timestamp];
}
