import 'dart:convert';

import 'package:study_abroad_cemc_mobile/models/enum.dart';

class UserAuthRegister {
  String? id;
  String? name;
  String? email;
  DateTime? emailVerified;
  String? password;
  String? image;
  String? studentCode;
  DateTime? dob;
  Gender? gender;
  String? phoneNumber;
  String? idCardNumber;
  String? address;
  String? schoolId;
  DegreeType? degreeType;
  CertificateType? certificateType;
  String? certificateImg;
  GradeType? gradeType;
  double? gradeScore;
  bool? isTwoFactorEnabled;
  StudentStatus? studentStatus;
  String? error;

  UserAuthRegister.none();

  UserAuthRegister({
    this.id,
    this.name,
    this.email,
    this.emailVerified,
    this.password,
    this.image,
    this.studentCode,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.idCardNumber,
    this.address,
    this.schoolId,
    this.degreeType,
    this.certificateType,
    this.certificateImg,
    this.gradeType,
    this.gradeScore,
    this.isTwoFactorEnabled,
    this.studentStatus,
    this.error,
  });

  factory UserAuthRegister.fromJson(Map<String, dynamic> json) {
    return UserAuthRegister(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerified: json['emailVerified'] != null
          ? DateTime.parse(json['emailVerified'])
          : null,
      password: json['password'],
      image: json['image'],
      studentCode: json['studentCode'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'] != null ? _parseGender(json['gender']) : null,
      phoneNumber: json['phoneNumber'],
      idCardNumber: json['idCardNumber'],
      address: json['address'],
      schoolId: json['schoolId'],
      degreeType: json['degreeType'] != null
          ? _parseDegreeType(json['degreeType'])
          : null,
      certificateType: json['certificateType'] != null
          ? _parseCertificateType(json['certificateType'])
          : null,
      certificateImg: json['certificateImg'],
      gradeType:
          json['gradeType'] != null ? _parseGradeType(json['gradeType']) : null,
      gradeScore: json['gradeScore'] != null
          ? double.parse(json['gradeScore'].toString())
          : null,
      isTwoFactorEnabled: json['isTwoFactorEnabled'],
      studentStatus: json['studentStatus'] != null
          ? _parseStudentStatus(json['studentStatus'])
          : null,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'emailVerified': emailVerified?.toIso8601String(),
      'password': password,
      'image': image,
      'studentCode': studentCode,
      'dob': dob?.toIso8601String(),
      'gender': gender?.toString(),
      'phoneNumber': phoneNumber,
      'idCardNumber': idCardNumber,
      'address': address,
      'schoolId': schoolId,
      'degreeType': degreeType?.toString(),
      'certificateType': certificateType?.toString(),
      'certificateImg': certificateImg,
      'gradeType': gradeType?.toString(),
      'gradeScore': gradeScore.toString(),
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'studentStatus': studentStatus?.toString(),
    };
  }

  static Gender? _parseGender(dynamic genderString) {
    if (genderString is String) {
      if (genderString.toUpperCase() == 'MALE') {
        return Gender.Male;
      } else if (genderString.toUpperCase() == 'FEMALE') {
        return Gender.Female;
      }
    }
    return null;
  }

  static DegreeType? _parseDegreeType(dynamic degreeTypeString) {
    if (degreeTypeString is String) {
      if (degreeTypeString.toUpperCase() == 'HIGHSCHOOL') {
        return DegreeType.Highschool;
      } else if (degreeTypeString.toUpperCase() == 'UNIVERSITY') {
        return DegreeType.University;
      }
    }
    return null;
  }

  static CertificateType? _parseCertificateType(dynamic certificateTypeString) {
    if (certificateTypeString is String) {
      if (certificateTypeString.toUpperCase() == 'IELTS') {
        return CertificateType.IELTS;
      } else if (certificateTypeString.toUpperCase() == 'TOEFL') {
        return CertificateType.TOEFL;
      }
    }
    return null;
  }

  static GradeType? _parseGradeType(dynamic gradeTypeString) {
    if (gradeTypeString is String) {
      if (gradeTypeString.toUpperCase() == 'GPA') {
        return GradeType.GPA;
      } else if (gradeTypeString.toUpperCase() == 'CGPA') {
        return GradeType.CGPA;
      }
    }
    return null;
  }

  static StudentStatus? _parseStudentStatus(dynamic studentStatusString) {
    if (studentStatusString is String) {
      if (studentStatusString.toUpperCase() == 'STUDYING') {
        return StudentStatus.STUDYING;
      } else if (studentStatusString.toUpperCase() == 'DROPPED') {
        return StudentStatus.DROPPED;
      } else if (studentStatusString.toUpperCase() == 'AWAITING') {
        return StudentStatus.AWAITING;
      } else if (studentStatusString.toUpperCase() == 'APPROVED') {
        return StudentStatus.APPROVED;
      }
    }
    return null;
  }

  static List<UserAuthRegister> parseList(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<UserAuthRegister>((json) => UserAuthRegister.fromJson(json))
        .toList();
  }
}
