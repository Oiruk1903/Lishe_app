import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}
