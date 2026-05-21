import '../../domain/repositories/weight_repository.dart';
import '../../domain/entities/weight_entry.dart';
import '../datasources/weight_local_datasource.dart';
import '../datasources/weight_remote_datasource.dart';
import '../models/weight_entry_model.dart';
import '../models/bmi_model.dart';

class WeightRepositoryImpl implements WeightRepository {
  final WeightLocalDataSource localDataSource;
  final WeightRemoteDataSource remoteDataSource;

  WeightRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<void> addWeightEntry({
    required String userId,
    required double weight,
    double? heightCm,
    String? note,
  }) async {
    final model = await remoteDataSource.logWeight({
      'weightKg': weight,
      if (heightCm != null) 'heightCm': heightCm,
      if (note != null) 'note': note,
    });
    final synced = model.copyWith(synced: true);
    await localDataSource.saveEntry(synced);
  }

  @override
  Future<List<WeightEntry>> getWeightHistory(String userId, {int days = 30}) async {
    try {
      final models = await remoteDataSource.getHistory(days: days);
      for (final m in models) {
        await localDataSource.saveEntry(m.copyWith(synced: true));
      }
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      final local = await localDataSource.getEntries(userId);
      return local.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<WeightEntry?> getCurrentWeight(String userId) async {
    try {
      final model = await remoteDataSource.getLatest();
      await localDataSource.saveEntry(model.copyWith(synced: true));
      return model.toEntity();
    } catch (_) {
      final model = await localDataSource.getLatestEntry(userId);
      return model?.toEntity();
    }
  }

  @override
  Future<BmiModel> getBmi() => remoteDataSource.getBmi();

  @override
  Future<Map<String, dynamic>> getTrends({int days = 30}) =>
      remoteDataSource.getTrends(days: days);

  @override
  Future<void> deleteEntry(String id) async {
    await remoteDataSource.deleteEntry(id);
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
    if (gender == 'male') {
      return 50 + 2.3 * ((heightCm - 152.4) / 2.54);
    } else {
      return 45.5 + 2.3 * ((heightCm - 152.4) / 2.54);
    }
  }

  @override
  DateTime calculateGoalDate(double currentWeight, double targetWeight) {
    final difference = (targetWeight - currentWeight).abs();
    final weeks = difference / 0.5;
    return DateTime.now().add(Duration(days: (weeks * 7).round()));
  }
}
