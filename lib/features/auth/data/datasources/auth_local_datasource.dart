import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _keyUser = 'current_user';
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';

  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_keyUser, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = prefs.getString(_keyUser);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await prefs.setString(_keyToken, token);
  }

  @override
  Future<String?> getAuthToken() async {
    return prefs.getString(_keyToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await prefs.setString(_keyRefreshToken, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return prefs.getString(_keyRefreshToken);
  }

  @override
  Future<void> clearAuthData() async {
    await prefs.remove(_keyUser);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRefreshToken);
  }
}
