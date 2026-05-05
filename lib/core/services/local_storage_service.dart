import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/user.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  static const String _keyAuthToken = 'auth_token';
  static const String _keyCurrentUser = 'current_user';

  LocalStorageService(this._prefs);

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  Future<String?> getAuthToken() async {
    return _prefs.getString(_keyAuthToken);
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

    final map = jsonDecode(userJson);
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      gender: map['gender'],
      cohort: map['cohort'],
      height: map['height']?.toDouble(),
      targetWeight: map['targetWeight']?.toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Future<void> clearAuthData() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyCurrentUser);
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('Must be overridden in main');
});
