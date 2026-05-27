part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorEmailState extends AuthState {
  final String message;
  const AuthErrorEmailState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorPasswordState extends AuthState {
  final String message;
  const AuthErrorPasswordState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorConfrimPasswordState extends AuthState {
  final String message;
  const AuthErrorConfrimPasswordState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorNameState extends AuthState {
  final String message;
  const AuthErrorNameState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorDOBState extends AuthState {
  final String message;
  const AuthErrorDOBState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorGenderErrorState extends AuthState {
  final String message;
  const AuthErrorGenderErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorPhoneState extends AuthState {
  final String message;
  const AuthErrorPhoneState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorIDCardNumberState extends AuthState {
  final String message;
  const AuthErrorIDCardNumberState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorCityState extends AuthState {
  final String message;
  const AuthErrorCityState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorDistrictState extends AuthState {
  final String message;
  const AuthErrorDistrictState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorWardState extends AuthState {
  final String message;
  const AuthErrorWardState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorAddressState extends AuthState {
  final String message;
  const AuthErrorAddressState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorDegreeTypeState extends AuthState {
  final String message;
  const AuthErrorDegreeTypeState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorGradeTypeState extends AuthState {
  final String message;
  const AuthErrorGradeTypeState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorGradeScore extends AuthState {
  final String message;
  const AuthErrorGradeScore(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorCertificateTypeState extends AuthState {
  final String message;
  const AuthErrorCertificateTypeState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthErrorNamedSchoolState extends AuthState {
  final String message;
  const AuthErrorNamedSchoolState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoadedState extends AuthState {
  final List<dynamic> schools;
  final List<String> countries;

  const AuthLoadedState({
    required this.schools,
    required this.countries,
  });

  @override
  List<Object?> get props => [schools, countries];
}

class AuthLoadedCityState extends AuthState {
  final List<dynamic> cities;
  final List<dynamic> country;

  const AuthLoadedCityState(this.cities, {this.country = const []});

  @override
  List<Object?> get props => [cities, country];
}

typedef ProvinceList = List<Province>;

class AuthSuccessState extends AuthState {
  final UserEntity user;

  const AuthSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthErrorState extends AuthState {
  final String message;
  final bool isNetworkError;

  const AuthErrorState(
    this.message, {
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}
