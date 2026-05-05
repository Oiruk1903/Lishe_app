import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile(UserProfileModel profile);
  Future<void> uploadProfileImage(String imagePath);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await dio.get(ApiEndpoints.profile);
    return UserProfileModel.fromJson(response.data);
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    final response = await dio.put(
      ApiEndpoints.profile,
      data: profile.toJson(),
    );
    return UserProfileModel.fromJson(response.data);
  }

  @override
  Future<void> uploadProfileImage(String imagePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath),
    });
    await dio.post('${ApiEndpoints.profile}/image', data: formData);
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await dio.post(
      ApiEndpoints.changePassword,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );
  }

  @override
  Future<void> deleteAccount() async {
    await dio.delete(ApiEndpoints.profile);
  }
}
