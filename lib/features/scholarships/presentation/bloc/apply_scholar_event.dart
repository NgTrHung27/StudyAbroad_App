part of 'apply_scholar_bloc.dart';

abstract class ApplyScholarEvent extends Equatable {
  const ApplyScholarEvent();

  @override
  List<Object?> get props => [];
}

class SendApplyScholarEvent extends ApplyScholarEvent {
  final String url;
  final String studentId;
  final String scholarshipId;
  final String additional;

  const SendApplyScholarEvent({
    required this.url,
    required this.studentId,
    required this.scholarshipId,
    required this.additional,
  });

  @override
  List<Object?> get props => [url, studentId, scholarshipId, additional];
}
