import 'package:lishe_app/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<void> updateProfile(UserProfile profile);
  Future<void> updatePassword(
      String userId, String oldPassword, String newPassword);
  Future<void> deleteAccount(String userId);
  Future<void> updateLanguage(String userId, String language);
  Future<void> updateNotificationSettings(
      String userId, Map<String, bool> settings);
}
