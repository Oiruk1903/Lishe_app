import '../repositories/profile_repository.dart';

class ChangeLanguageUseCase {
  final ProfileRepository _repository;

  ChangeLanguageUseCase(this._repository);

  Future<void> execute(String userId, String language) async {
    await _repository.updateLanguage(userId, language);
  }
}
