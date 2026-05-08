import 'package:lishe_app/features/community/domain/models/challenge.dart';

abstract class ChallengeRepository {
  Future<List<Challenge>> fetchChallenges();
}
