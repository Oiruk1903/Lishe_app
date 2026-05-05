import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required String gender,
    required String password,
  });

  Future<User> login({
    required String email,
    required String password,
  });

  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> updateUserCohort(String cohortId);
  Future<void> updateUserProfile(User user);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> requestPasswordReset(String email);
  Future<bool> verifyResetCode(String email, String code);
  Future<void> resetPassword(String email, String code, String newPassword);
}
