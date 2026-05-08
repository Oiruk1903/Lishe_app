import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_constants.dart';
import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getProfile(String userId);
  Future<void> saveProfile(UserProfileModel profile);
  Future<void> updateProfile(UserProfileModel profile);
  Future<void> deleteProfile(String userId);
  Future<void> updateLanguage(String userId, String language);
  Future<void> updateNotificationSettings(
      String userId, Map<String, bool> settings);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final DatabaseHelper _dbHelper;

  ProfileLocalDataSourceImpl(this._dbHelper);

  @override
  Future<UserProfileModel?> getProfile(String userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [userId],
    );

    if (maps.isEmpty) return null;
    return UserProfileModel.fromMap(maps.first);
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseConstants.tableUsers,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateProfile(UserProfileModel profile) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseConstants.tableUsers,
      {
        DatabaseConstants.columnFullName: profile.fullName,
        DatabaseConstants.columnEmail: profile.email,
        DatabaseConstants.columnPhoneNumber: profile.phoneNumber,
        DatabaseConstants.columnDateOfBirth:
            profile.dateOfBirth.toIso8601String(),
        DatabaseConstants.columnGender: profile.gender,
        DatabaseConstants.columnCohort: profile.cohort,
        DatabaseConstants.columnProfileImage: profile.profileImage,
        DatabaseConstants.columnHeight: profile.height,
        DatabaseConstants.columnTargetWeight: profile.targetWeight,
        DatabaseConstants.columnPreferredLanguage: profile.preferredLanguage,
        DatabaseConstants.columnNotificationSettings:
            profile.notificationSettings,
        DatabaseConstants.columnUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [profile.id],
    );
  }

  @override
  Future<void> deleteProfile(String userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> updateLanguage(String userId, String language) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseConstants.tableUsers,
      {DatabaseConstants.columnPreferredLanguage: language},
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> updateNotificationSettings(
      String userId, Map<String, bool> settings) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseConstants.tableUsers,
      {DatabaseConstants.columnNotificationSettings: settings},
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [userId],
    );
  }
}
