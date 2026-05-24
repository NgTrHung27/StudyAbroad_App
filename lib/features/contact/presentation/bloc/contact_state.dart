part of 'contact_bloc.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object?> get props => [];
}

class ContactInitialState extends ContactUsState {}

class ContactLoadingState extends ContactUsState {}

class ContactErrorTitleErrorState extends ContactUsState {
  final String error;
  const ContactErrorTitleErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class ContactLoadedNamedSchoolState extends ContactUsState {
  final List<Schools> school;
  const ContactLoadedNamedSchoolState(this.school);

  @override
  List<Object?> get props => [school];
}

class ContactErrorNamedSchoolState extends ContactUsState {
  final String error;
  const ContactErrorNamedSchoolState(this.error);

  @override
  List<Object?> get props => [error];
}

class ContactSuccessState extends ContactUsState {}

class ContactErrorState extends ContactUsState {
  final String error;
  final bool isNetworkError;

  const ContactErrorState(this.error, {this.isNetworkError = false});

  @override
  List<Object?> get props => [error, isNetworkError];
}

class ContactErrorEmailState extends ContactUsState {
  final String error;
  const ContactErrorEmailState(this.error);

  @override
  List<Object?> get props => [error];
}
