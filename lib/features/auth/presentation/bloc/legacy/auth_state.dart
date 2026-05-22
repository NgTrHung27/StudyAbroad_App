import 'package:study_abroad_cemc_mobile/models/country.dart';
import 'package:study_abroad_cemc_mobile/models/schools.dart';
import 'package:study_abroad_cemc_mobile/models/user_register.dart';

abstract class AuthState {}

//Suceess
class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final UserAuthRegister userAuthRegister;
  AuthSuccessState(this.userAuthRegister);
}

//Email
class AuthErrorEmailState extends AuthState {
  final String error;
  AuthErrorEmailState(this.error);
}

//Password - ConfrimPassword
class AuthErrorPasswordState extends AuthState {
  final String error;
  AuthErrorPasswordState(this.error);
}

class AuthErrorConfrimPasswordState extends AuthState {
  final String error;
  AuthErrorConfrimPasswordState(this.error);
}

//Name
class AuthErrorNameState extends AuthState {
  final String error;
  AuthErrorNameState(this.error);
}

//DOB
class AuthErrorDOBState extends AuthState {
  final String error;
  AuthErrorDOBState(this.error);
}

//Gender
class AuthErrorGenderErrorState extends AuthState {
  final String error;
  AuthErrorGenderErrorState(this.error);
}

//Phone
class AuthErrorPhoneState extends AuthState {
  final String error;
  AuthErrorPhoneState(this.error);
}

//IDCard
class AuthErrorIDCardNumberState extends AuthState {
  final String error;
  AuthErrorIDCardNumberState(this.error);
}

//City - District - Ward - Address
class AuthLoadedCityState extends AuthState {
  final List<Country> country;
  AuthLoadedCityState(this.country);
}

class AuthErrorCityState extends AuthState {
  final String error;
  AuthErrorCityState(this.error);
}

class AuthErrorDistrictState extends AuthState {
  final String error;
  AuthErrorDistrictState(this.error);
}

class AuthErrorWardState extends AuthState {
  final String error;
  AuthErrorWardState(this.error);
}

//Address
class AuthErrorAddressState extends AuthState {
  final String error;
  AuthErrorAddressState(this.error);
}

//School - Program
class AuthLoadedNamedSchoolState extends AuthState {
  final List<Schools> school;
  AuthLoadedNamedSchoolState(this.school);
}

//
class AuthLoadedState extends AuthState {
  final List<Schools> schools;
  final List<String> countries;
  AuthLoadedState({required this.schools, required this.countries});
}
class AuthErrorNamedSchoolState extends AuthState {
  final String error;
  AuthErrorNamedSchoolState(this.error);
}

class AuthLoadedCountryState extends AuthState {
  final List<String> countries;
  AuthLoadedCountryState(this.countries);
}

class AuthLoadedProgramState extends AuthState {
  final List<Schools> program;
  AuthLoadedProgramState(this.program);
}

class AuthErrorProgramState extends AuthState {
  final String error;
  AuthErrorProgramState(this.error);
}

//Degree - Certificate - CertifcateIMG
class AuthErrorDegreeTypeState extends AuthState {
  final String error;
  AuthErrorDegreeTypeState(this.error);
}

class AuthErrorCertificateTypeState extends AuthState {
  final String error;
  AuthErrorCertificateTypeState(this.error);
}

class AuthErrorCertificateImgState extends AuthState {
  final String error;
  AuthErrorCertificateImgState(this.error);
}

//GradeType - GradeScore
class AuthErrorGradeTypeState extends AuthState {
  final String error;
  AuthErrorGradeTypeState(this.error);
}

class AuthErrorGradeScore extends AuthState {
  final String error;
  AuthErrorGradeScore(this.error);
}

//Error API
class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}
