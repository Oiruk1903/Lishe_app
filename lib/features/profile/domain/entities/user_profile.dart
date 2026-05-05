import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final DateTime dateOfBirth;
  final String gender;
  final String? cohort;
  final String? profileImage;
  final double? height;
  final double? targetWeight;
  final String preferredLanguage;
  final Map<String, bool> notificationSettings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    this.cohort,
    this.profileImage,
    this.height,
    this.targetWeight,
    required this.preferredLanguage,
    required this.notificationSettings,
    required this.createdAt,
    this.updatedAt,
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? cohort,
    String? profileImage,
    double? height,
    double? targetWeight,
    String? preferredLanguage,
    Map<String, bool>? notificationSettings,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      cohort: cohort ?? this.cohort,
      profileImage: profileImage ?? this.profileImage,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'cohort': cohort,
      'profileImage': profileImage,
      'height': height,
      'targetWeight': targetWeight,
      'preferredLanguage': preferredLanguage,
      'notificationSettings': notificationSettings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        dateOfBirth,
        gender,
        cohort,
        height,
        targetWeight,
        preferredLanguage,
        createdAt,
        updatedAt,
      ];
}
