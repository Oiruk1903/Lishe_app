import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required String gender,
    required String password,
  }) async {
    final response = await remoteDataSource.register({
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'password': password,
    });

    final user = UserModel.fromJson(response['user']).toEntity();
    final token = response['token'] as String;
    final refreshToken = response['refresh_token'] as String?;

    await localDataSource.saveUser(UserModel.fromEntity(user));
    await localDataSource.saveAuthToken(token);
    if (refreshToken != null) {
      await localDataSource.saveRefreshToken(refreshToken);
    }

    return user;
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(email, password);

    final user = UserModel.fromJson(response['user']).toEntity();
    final token = response['token'] as String;
    final refreshToken = response['refresh_token'] as String?;

    await localDataSource.saveUser(UserModel.fromEntity(user));
    await localDataSource.saveAuthToken(token);
    if (refreshToken != null) {
      await localDataSource.saveRefreshToken(refreshToken);
    }

    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {
      // Ignore remote errors on logout
    }
    await localDataSource.clearAuthData();
  }

  @override
  Future<User?> getCurrentUser() async {
    final localUser = await localDataSource.getUser();
    if (localUser != null) {
      return localUser.toEntity();
    }

    try {
      final remoteUser = await remoteDataSource.getProfile();
      final userModel = UserModel.fromJson(remoteUser);
      await localDataSource.saveUser(userModel);
      return userModel.toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateUserCohort(String cohortId) async {
    await remoteDataSource.updateProfile({'cohort': cohortId});
    final currentUser = await localDataSource.getUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(cohort: cohortId);
      await localDataSource.saveUser(updatedUser);
    }
  }

  @override
  Future<void> updateUserProfile(User user) async {
    final userModel = UserModel.fromEntity(user);
    await remoteDataSource.updateProfile(userModel.toJson());
    await localDataSource.saveUser(userModel);
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await remoteDataSource.requestPasswordReset(email);
  }

  @override
  Future<bool> verifyResetCode(String email, String code) async {
    return await remoteDataSource.verifyResetCode(email, code);
  }

  @override
  Future<void> resetPassword(
      String email, String code, String newPassword) async {
    await remoteDataSource.resetPassword(email, code, newPassword);
  }
}
