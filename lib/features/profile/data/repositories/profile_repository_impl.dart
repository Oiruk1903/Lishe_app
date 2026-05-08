import 'package:lishe_app/features/profile/data/dataresources/profile_local_datasource.dart';
import 'package:lishe_app/features/profile/data/dataresources/profile_remote_datasource.dart';

import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<UserProfile?> getProfile(String userId) async {
    // Try local first
    final localProfile = await localDataSource.getProfile(userId);
    if (localProfile != null) {
      return localProfile.toEntity();
    }

    // Fallback to remote
    try {
      final remoteProfile = await remoteDataSource.getProfile();
      await localDataSource.saveProfile(remoteProfile);
      return remoteProfile.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);

    // Update local
    await localDataSource.updateProfile(model);

    // Sync to remote
    try {
      final updated = await remoteDataSource.updateProfile(model);
      await localDataSource.saveProfile(updated);
    } catch (e) {
      // Will sync later
    }
  }

  @override
  Future<void> updatePassword(
      String userId, String oldPassword, String newPassword) async {
    await remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<void> deleteAccount(String userId) async {
    await remoteDataSource.deleteAccount();
    await localDataSource.deleteProfile(userId);
  }

  @override
  Future<void> updateLanguage(String userId, String language) async {
    await localDataSource.updateLanguage(userId, language);
    // Sync to remote if needed
    try {
      await remoteDataSource.updateProfile(
        UserProfileModel(
          id: userId,
          fullName: '',
          email: '',
          dateOfBirth: DateTime.now(),
          gender: '',
          preferredLanguage: language,
          notificationSettings: {},
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // Will sync later
    }
  }

  @override
  Future<void> updateNotificationSettings(
      String userId, Map<String, bool> settings) async {
    await localDataSource.updateNotificationSettings(userId, settings);
    // Sync to remote if needed
    try {
      await remoteDataSource.updateProfile(
        UserProfileModel(
          id: userId,
          fullName: '',
          email: '',
          dateOfBirth: DateTime.now(),
          gender: '',
          preferredLanguage: '',
          notificationSettings: settings,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // Will sync later
    }
  }

  Future<void> uploadProfileImage(String userId, String imagePath) async {
    await remoteDataSource.uploadProfileImage(imagePath);
    // Refresh profile after upload
    final remoteProfile = await remoteDataSource.getProfile();
    await localDataSource.saveProfile(remoteProfile);
  }
}
