import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
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
    @Default('sw') String preferredLanguage,
    @Default({}) Map<String, bool> notificationSettings,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromEntity(UserProfile profile) => UserProfileModel(
        id: profile.id,
        fullName: profile.fullName,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        dateOfBirth: profile.dateOfBirth,
        gender: profile.gender,
        cohort: profile.cohort,
        profileImage: profile.profileImage,
        height: profile.height,
        targetWeight: profile.targetWeight,
        preferredLanguage: profile.preferredLanguage,
        notificationSettings: profile.notificationSettings,
        createdAt: profile.createdAt,
        updatedAt: profile.updatedAt,
      );

  // Custom fromMap for SQLite
  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone_number'] as String?,
      dateOfBirth: DateTime.parse(map['date_of_birth'] as String),
      gender: map['gender'] as String,
      cohort: map['cohort'] as String?,
      profileImage: map['profile_image'] as String?,
      height: (map['height'] as num?)?.toDouble(),
      targetWeight: (map['target_weight'] as num?)?.toDouble(),
      preferredLanguage: map['preferred_language'] as String? ?? 'sw',
      notificationSettings: map['notification_settings'] != null
          ? Map<String, bool>.from(
              map['notification_settings'] as Map,
            )
          : {},
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}

extension UserProfileModelX on UserProfileModel {
  UserProfile toEntity() => UserProfile(
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
        preferredLanguage: preferredLanguage,
        notificationSettings: notificationSettings,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'cohort': cohort,
      'profile_image': profileImage,
      'height': height,
      'target_weight': targetWeight,
      'preferred_language': preferredLanguage,
      'notification_settings': notificationSettings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
