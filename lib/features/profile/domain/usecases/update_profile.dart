import '../repositories/profile_repository.dart';
import '../entities/user_profile.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<void> execute(UserProfile profile) async {
    await _repository.updateProfile(profile);
  }
}
