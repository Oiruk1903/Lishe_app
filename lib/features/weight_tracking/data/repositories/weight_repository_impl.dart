import 'package:uuid/uuid.dart';
import '../../domain/repositories/weight_repository.dart';
import '../../domain/entities/weight_entry.dart';
import '../datasources/weight_local_datasource.dart';
import '../models/weight_entry_model.dart';

class WeightRepositoryImpl implements WeightRepository {
  final WeightLocalDataSource localDataSource;

  WeightRepositoryImpl(this.localDataSource);

  @override
  Future<void> addWeightEntry({
    required String userId,
    required double weight,
    String? note,
  }) async {
    final entry = WeightEntry(
      id: const Uuid().v4(),
      userId: userId,
      weight: weight,
      recordedAt: DateTime.now(),
      note: note,
    );
    final model = WeightEntryModel.fromEntity(entry);
    await localDataSource.saveEntry(model);
  }

  @override
  Future<List<WeightEntry>> getWeightHistory(String userId) async {
    final models = await localDataSource.getEntries(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<WeightEntry?> getCurrentWeight(String userId) async {
    final model = await localDataSource.getLatestEntry(userId);
    return model?.toEntity();
  }

  @override
  Future<void> deleteEntry(String id) async {
    await localDataSource.deleteEntry(id);
  }

  @override
  double calculateBMI(double weightKg, double heightCm) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  @override
  String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Upungufu wa Uzito';
    if (bmi < 25) return 'Kawaida';
    if (bmi < 30) return 'Uzito Kupita Kiasi';
    return 'Unene Kupindukia';
  }

  @override
  double getIdealWeight(double heightCm, String gender) {
    // Devine formula
    if (gender == 'male') {
      return 50 + 2.3 * ((heightCm - 152.4) / 2.54);
    } else {
      return 45.5 + 2.3 * ((heightCm - 152.4) / 2.54);
    }
  }

  @override
  DateTime calculateGoalDate(double currentWeight, double targetWeight) {
    final difference = (targetWeight - currentWeight).abs();
    final weeks = difference / 0.5; // Safe rate: 0.5 kg per week
    return DateTime.now().add(Duration(days: (weeks * 7).round()));
  }
}
