import '../repositories/auth_repository.dart';

class LogoutUserUseCase {
  final AuthRepository repository;

  LogoutUserUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
