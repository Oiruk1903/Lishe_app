import 'dart:math';
import '../models/plate_analysis_result.dart';

class TFLiteService {
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Simulate model initialization
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
  }

  Future<PlateAnalysisResult> analyzeImage(dynamic imageFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Simulate AI analysis with mock predictions
    await Future.delayed(const Duration(seconds: 2));

    // Mock predictions for Tanzanian food groups
    final random = Random();
    final predictions = <String, double>{
      'Wanga': random.nextDouble() * 0.4 + 0.3, // 30-70%
      'Protini': random.nextDouble() * 0.3 + 0.1, // 10-40%
      'Mboga': random.nextDouble() * 0.3 + 0.1, // 10-40%
      'Matunda': random.nextDouble() * 0.1, // 0-10%
      'Nafaka': random.nextDouble() * 0.2, // 0-20%
    };

    // Normalize to ensure sum = 1.0
    final total = predictions.values.reduce((a, b) => a + b);
    final normalizedPredictions =
        predictions.map((key, value) => MapEntry(key, value / total));

    // Generate recommendations based on analysis
    final recommendations = _generateRecommendations(normalizedPredictions);

    return PlateAnalysisResult(
      predictions: normalizedPredictions,
      recommendations: recommendations,
      timestamp: DateTime.now(),
    );
  }

  List<String> _generateRecommendations(Map<String, double> predictions) {
    final recommendations = <String>[];
    final carbs = predictions['Wanga'] ?? 0;
    final protein = predictions['Protini'] ?? 0;
    final veggies = predictions['Mboga'] ?? 0;

    if (carbs > 0.6) {
      recommendations.add('Punguza wanga na ongeza mboga zaidi');
    }

    if (protein < 0.15) {
      recommendations.add('Ongeza chakula cha protini kama maharage au samaki');
    }

    if (veggies < 0.2) {
      recommendations.add('Kula mboga za kijani kila siku');
    }

    if (carbs >= 0.2 && protein >= 0.15 && veggies >= 0.15) {
      recommendations.add(
          'Chakula chako kimechanganywa vizuri! Endelea kula vyakula vyenye lishe bora.');
    }

    recommendations.add('Kunywa maji mengi baada ya mlo');

    return recommendations;
  }

  void dispose() {
    _isInitialized = false;
  }
}
