import 'package:equatable/equatable.dart';

/// User entity representing authenticated user
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final DateTime? dob;
  final String? phoneNumber;
  final String? image;
  final bool isLocked;
  final String? token;
  final StudentEntity? student;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.dob,
    this.phoneNumber,
    this.image,
    this.isLocked = false,
    this.token,
    this.student,
  });

  /// Check if user has completed profile
  bool get hasCompletedProfile => student != null;

  /// Get display name
  String get displayName => name ?? email.split('@').first;

  @override
  List<Object?> get props => [id, email, name, dob, phoneNumber, isLocked, token, student];
}

/// Student entity
class StudentEntity extends Equatable {
  final String id;
  final String? studentCode;
  final String? schoolName;
  final String? country;
  final String? programName;
  final String? degreeType;
  final List<String>? scholarships;
  final SchoolEntity? school;

  const StudentEntity({
    required this.id,
    this.studentCode,
    this.schoolName,
    this.country,
    this.programName,
    this.degreeType,
    this.scholarships,
    this.school,
  });

  @override
  List<Object?> get props => [id, studentCode, schoolName, country, programName, degreeType];
}

/// School entity for student
class SchoolEntity extends Equatable {
  final String id;
  final String name;
  final String? country;
  final String? image;
  final String? logo;
  final String? description;
  final String? address;
  final String? website;
  final double? ranking;
  final int? tuitionMin;
  final int? tuitionMax;

  const SchoolEntity({
    required this.id,
    required this.name,
    this.country,
    this.image,
    this.logo,
    this.description,
    this.address,
    this.website,
    this.ranking,
    this.tuitionMin,
    this.tuitionMax,
  });

  @override
  List<Object?> get props => [id, name, country, image, logo];
}
