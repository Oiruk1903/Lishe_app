import '../entities/weight_entry.dart';

abstract class WeightRepository {
  Future<void> addWeightEntry(
      {required String userId, required double weight, String? note});
  Future<List<WeightEntry>> getWeightHistory(String userId);
  Future<WeightEntry?> getCurrentWeight(String userId);
  double calculateBMI(double weightKg, double heightCm);
  String getBMICategory(double bmi);
  Future<void> deleteEntry(String id);
  double getIdealWeight(double heightCm, String gender);
  DateTime calculateGoalDate(double currentWeight, double targetWeight);
}
