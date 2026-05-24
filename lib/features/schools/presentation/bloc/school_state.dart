import 'package:equatable/equatable.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';

abstract class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object?> get props => [];
}

class SchoolsInitial extends SchoolState {}

class SchoolsLoading extends SchoolState {}

class SchoolsLoaded extends SchoolState {
  final List<SchoolEntity> schoolList;

  const SchoolsLoaded({required this.schoolList});

  @override
  List<Object?> get props => [schoolList];
}

class SchoolDetailLoaded extends SchoolState {
  final SchoolEntity school;

  const SchoolDetailLoaded({required this.school});

  @override
  List<Object?> get props => [school];
}

class SchoolsError extends SchoolState {
  final String message;
  final SchoolsFailure? failure;

  const SchoolsError({required this.message, this.failure});

  @override
  List<Object?> get props => [message, failure];
}
