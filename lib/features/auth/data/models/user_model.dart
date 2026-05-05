import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String fullName,
    required String email,
    String? phoneNumber,
    required DateTime dateOfBirth,
    required String gender,
    String? cohort,
    String? profileImage,
    double? height,
    double? targetWeight,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        dateOfBirth: user.dateOfBirth,
        gender: user.gender,
        cohort: user.cohort,
        profileImage: user.profileImage,
        height: user.height,
        targetWeight: user.targetWeight,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
}

extension UserModelX on UserModel {
  User toEntity() => User(
        id: id,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        gender: gender,
        cohort: cohort,
        profileImage: profileImage,
        height: height,
        targetWeight: targetWeight,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
