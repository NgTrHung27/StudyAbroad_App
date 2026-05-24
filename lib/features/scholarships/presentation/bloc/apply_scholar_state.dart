part of 'apply_scholar_bloc.dart';

abstract class ApplyScholarState extends Equatable {
  const ApplyScholarState();

  @override
  List<Object?> get props => [];
}

class ApplyScholarInitial extends ApplyScholarState {}

class ApplyScholarLoading extends ApplyScholarState {}

class ApplyScholarSuccess extends ApplyScholarState {
  final ApplyScholarModel applyScholarModel;

  const ApplyScholarSuccess(this.applyScholarModel);

  @override
  List<Object?> get props => [applyScholarModel];
}

class ApplyScholarFailure extends ApplyScholarState {
  final ApplyScholarModel? applyScholarModel;
  final String? error;

  const ApplyScholarFailure({this.applyScholarModel, this.error});

  @override
  List<Object?> get props => [applyScholarModel, error];
}

class ApplyScholarError extends ApplyScholarState {
  final String error;
  final bool isNetworkError;

  const ApplyScholarError(this.error, {this.isNetworkError = false});

  @override
  List<Object?> get props => [error, isNetworkError];
}
