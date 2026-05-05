import '../repositories/weight_repository.dart';
import '../entities/weight_entry.dart';

class GetWeightHistoryUseCase {
  final WeightRepository repository;

  GetWeightHistoryUseCase(this.repository);

  Future<List<WeightEntry>> call(String userId) {
    return repository.getWeightHistory(userId);
  }
}
