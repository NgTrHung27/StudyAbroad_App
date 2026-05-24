import 'package:equatable/equatable.dart';

class ApplyScholarModel extends Equatable {
  final String? studentId;
  final String? scholarshipId;
  final String? additional;
  final String? status;
  final String? error;

  const ApplyScholarModel({
    this.studentId,
    this.scholarshipId,
    this.additional,
    this.status,
    this.error,
  });

  factory ApplyScholarModel.fromJson(Map<String, dynamic> json) {
    return ApplyScholarModel(
      studentId: json['studentId'],
      scholarshipId: json['scholarshipId'],
      additional: json['additional'],
      status: json['status'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'scholarshipId': scholarshipId,
      'additional': additional,
      'status': status,
      'error': error,
    };
  }

  @override
  List<Object?> get props =>
      [studentId, scholarshipId, additional, status, error];
}
