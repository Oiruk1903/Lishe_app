import '../entities/weight_entry.dart';
import '../../data/models/bmi_model.dart';

abstract class WeightRepository {
  Future<void> addWeightEntry({
    required String userId,
    required double weight,
    double? heightCm,
    String? note,
  });
  Future<List<WeightEntry>> getWeightHistory(String userId, {int days = 30});
  Future<WeightEntry?> getCurrentWeight(String userId);
  Future<BmiModel> getBmi();
  Future<Map<String, dynamic>> getTrends({int days = 30});
  Future<void> deleteEntry(String id);
  double calculateBMI(double weightKg, double heightCm);
  String getBMICategory(double bmi);
  double getIdealWeight(double heightCm, String gender);
  DateTime calculateGoalDate(double currentWeight, double targetWeight);
}
