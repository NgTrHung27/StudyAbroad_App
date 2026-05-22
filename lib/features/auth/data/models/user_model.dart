import 'package:study_abroad_cemc_mobile/features/auth/domain/entities/user_entity.dart';

/// User model for API responses
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.dob,
    super.phoneNumber,
    super.image,
    super.isLocked,
    super.token,
    super.student,
  });

  /// Create from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      dob: json['dob'] != null ? DateTime.tryParse(json['dob'] as String) : null,
      phoneNumber: json['phoneNumber'] as String?,
      image: json['image'] as String?,
      isLocked: json['isLocked'] as bool? ?? false,
      token: json['token'] as String?,
      student: json['student'] != null
          ? StudentModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'dob': dob?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'image': image,
      'isLocked': isLocked,
      'token': token,
      'student': student != null ? (student as StudentModel?)?.toJson() : null,
    };
  }

  /// Create empty instance
  factory UserModel.empty() {
    return const UserModel(
      id: '',
      email: '',
      name: null,
      dob: null,
      phoneNumber: null,
      image: null,
      isLocked: false,
      token: null,
      student: null,
    );
  }

  /// Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      dob: dob,
      phoneNumber: phoneNumber,
      image: image,
      isLocked: isLocked,
      token: token,
      student: student,
    );
  }
}

/// Student model
class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    super.studentCode,
    super.schoolName,
    super.country,
    super.programName,
    super.degreeType,
    super.scholarships,
    super.school,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String? ?? '',
      studentCode: json['studentCode'] as String?,
      schoolName: json['schoolName'] as String?,
      country: json['country'] as String?,
      programName: json['programName'] as String?,
      degreeType: json['degreeType'] as String?,
      scholarships: (json['scholarships'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      school: json['school'] != null
          ? SchoolModel.fromJson(json['school'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentCode': studentCode,
      'schoolName': schoolName,
      'country': country,
      'programName': programName,
      'degreeType': degreeType,
      'scholarships': scholarships,
      'school': school != null ? (school as SchoolModel?)?.toJson() : null,
    };
  }

  factory StudentModel.empty() {
    return const StudentModel(id: '');
  }
}

/// School model
class SchoolModel extends SchoolEntity {
  const SchoolModel({
    required super.id,
    required super.name,
    super.country,
    super.image,
    super.logo,
    super.description,
    super.address,
    super.website,
    super.ranking,
    super.tuitionMin,
    super.tuitionMax,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      country: json['country'] as String?,
      image: json['image'] as String?,
      logo: json['logo'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      website: json['website'] as String?,
      ranking: (json['ranking'] as num?)?.toDouble(),
      tuitionMin: json['tuitionMin'] as int?,
      tuitionMax: json['tuitionMax'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'image': image,
      'logo': logo,
      'description': description,
      'address': address,
      'website': website,
      'ranking': ranking,
      'tuitionMin': tuitionMin,
      'tuitionMax': tuitionMax,
    };
  }
}
