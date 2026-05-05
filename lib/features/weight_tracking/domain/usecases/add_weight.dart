import '../repositories/weight_repository.dart';

class AddWeightUseCase {
  final WeightRepository repository;

  AddWeightUseCase(this.repository);

  Future<void> call({
    required String userId,
    required double weight,
    String? note,
  }) async {
    await repository.addWeightEntry(
      userId: userId,
      weight: weight,
      note: note,
    );
  }
}
