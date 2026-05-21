import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/user.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyCurrentUser = 'current_user';

  LocalStorageService(this._prefs);

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  Future<String?> getAuthToken() async {
    return _prefs.getString(_keyAuthToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_keyRefreshToken, token);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_keyRefreshToken);
  }

  Future<void> saveCurrentUser(User user) async {
    final userJson = jsonEncode({
      'id': user.id,
      'fullName': user.fullName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'dateOfBirth': user.dateOfBirth.toIso8601String(),
      'gender': user.gender,
      'cohort': user.cohort,
      'height': user.height,
      'targetWeight': user.targetWeight,
      'createdAt': user.createdAt.toIso8601String(),
    });
    await _prefs.setString(_keyCurrentUser, userJson);
  }

  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString(_keyCurrentUser);
    if (userJson == null) return null;

    final map = jsonDecode(userJson) as Map<String, dynamic>;
    return User(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth'] as String)
          : DateTime(1990, 1, 1),
      gender: (map['gender'] as String?) ?? '',
      cohort: map['cohort'] as String?,
      height: (map['height'] as num?)?.toDouble(),
      targetWeight: (map['targetWeight'] as num?)?.toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Future<void> clearAuthData() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyRefreshToken);
    await _prefs.remove(_keyCurrentUser);
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('Must be overridden in main');
});
