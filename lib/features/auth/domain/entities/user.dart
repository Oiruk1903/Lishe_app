import 'package:equatable/equatable.dart';

class User extends Equatable {
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
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
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
    required this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? cohort,
    String? profileImage,
    double? height,
    double? targetWeight,
    DateTime? updatedAt,
  }) {
    return User(
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
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
        createdAt,
        updatedAt,
      ];
}
