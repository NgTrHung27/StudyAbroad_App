import 'package:equatable/equatable.dart';

class ApplyScholarEntity extends Equatable {
  final String? studentId;
  final String? scholarshipId;
  final String? additional;
  final String? status;
  final String? error;

  const ApplyScholarEntity({
    this.studentId,
    this.scholarshipId,
    this.additional,
    this.status,
    this.error,
  });

  @override
  List<Object?> get props =>
      [studentId, scholarshipId, additional, status, error];
}
