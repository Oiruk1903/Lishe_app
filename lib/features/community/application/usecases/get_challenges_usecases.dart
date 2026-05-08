// application/fetch_challenges_usecase.dart
import '../../domain/models/challenge.dart';
import '../../domain/repositories/challenge_repository.dart';


class FetchChallengesUseCase {
  final ChallengeRepository repository;

  FetchChallengesUseCase(this.repository);

  Future<List<Challenge>> call() async {
    return await repository.fetchChallenges();
  }
}
