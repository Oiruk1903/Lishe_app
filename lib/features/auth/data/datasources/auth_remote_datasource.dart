import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> register(Map<String, dynamic> data);
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> getProfile();
  Future<void> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> requestPasswordReset(String email);
  Future<bool> verifyResetCode(String email, String code);
  Future<void> resetPassword(String email, String code, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await dio.post(ApiEndpoints.register, data: data);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  @override
  Future<void> logout() async {
    await dio.post(ApiEndpoints.logout);
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    final response = await dio.get(ApiEndpoints.profile);
    return response.data;
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await dio.put(ApiEndpoints.profile, data: data);
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await dio.post(
      ApiEndpoints.changePassword,
      data: {'old_password': oldPassword, 'new_password': newPassword},
    );
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await dio.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  @override
  Future<bool> verifyResetCode(String email, String code) async {
    final response = await dio.post(
      '${ApiEndpoints.forgotPassword}/verify',
      data: {'email': email, 'code': code},
    );
    return response.data['valid'] as bool;
  }

  @override
  Future<void> resetPassword(
      String email, String code, String newPassword) async {
    await dio.post(
      '${ApiEndpoints.forgotPassword}/reset',
      data: {'email': email, 'code': code, 'new_password': newPassword},
    );
  }
}
