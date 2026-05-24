part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckEmailEvent extends AuthEvent {
  final String email;
  const CheckEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class CheckPasswordEvent extends AuthEvent {
  final String password;
  const CheckPasswordEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class CheckConfirmPasswordEvent extends AuthEvent {
  final String password;
  final String confirmPassword;
  const CheckConfirmPasswordEvent(this.password, this.confirmPassword);

  @override
  List<Object?> get props => [password, confirmPassword];
}

class CheckNameEvent extends AuthEvent {
  final String name;
  const CheckNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class CheckDobEvent extends AuthEvent {
  final DateTime dob;
  const CheckDobEvent(this.dob);

  @override
  List<Object?> get props => [dob];
}

class CheckGenderEvent extends AuthEvent {
  final String gender;
  const CheckGenderEvent(this.gender);

  @override
  List<Object?> get props => [gender];
}

class CheckPhoneNumberEvent extends AuthEvent {
  final String phoneNumber;
  const CheckPhoneNumberEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class CheckIdCardNumberEvent extends AuthEvent {
  final String idCardNumber;
  const CheckIdCardNumberEvent(this.idCardNumber);

  @override
  List<Object?> get props => [idCardNumber];
}

class CheckCityEvent extends AuthEvent {
  final String city;
  const CheckCityEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class CheckDistrictEvent extends AuthEvent {
  final String district;
  const CheckDistrictEvent(this.district);

  @override
  List<Object?> get props => [district];
}

class CheckWardEvent extends AuthEvent {
  final String ward;
  const CheckWardEvent(this.ward);

  @override
  List<Object?> get props => [ward];
}

class CheckAddressEvent extends AuthEvent {
  final String address;
  const CheckAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class CheckSchoolNameEvent extends AuthEvent {
  final String schoolName;
  const CheckSchoolNameEvent(this.schoolName);

  @override
  List<Object?> get props => [schoolName];
}

class CheckProgramNameEvent extends AuthEvent {
  final String programName;
  const CheckProgramNameEvent(this.programName);

  @override
  List<Object?> get props => [programName];
}

class CheckDegreeTypeEvent extends AuthEvent {
  final String degreeType;
  const CheckDegreeTypeEvent(this.degreeType);

  @override
  List<Object?> get props => [degreeType];
}

class CheckCertificateTypeEvent extends AuthEvent {
  final String certificateType;
  const CheckCertificateTypeEvent(this.certificateType);

  @override
  List<Object?> get props => [certificateType];
}

class CheckCertificateImgEvent extends AuthEvent {
  final String certificateImg;
  const CheckCertificateImgEvent(this.certificateImg);

  @override
  List<Object?> get props => [certificateImg];
}

class CheckGradeTypeEvent extends AuthEvent {
  final String gradeType;
  const CheckGradeTypeEvent(this.gradeType);

  @override
  List<Object?> get props => [gradeType];
}

class CheckGradeScoreEvent extends AuthEvent {
  final double gradeScore;
  const CheckGradeScoreEvent(this.gradeScore);

  @override
  List<Object?> get props => [gradeScore];
}

class GetSchoolsAndCountriesEvent extends AuthEvent {}

class GetCityEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;
  final String confirmPassword;
  final String idCardNumber;
  final DateTime date;
  final String phone;
  final String? selectedSchool;
  final String? selectedCountry;
  final String? selectedProgram;
  final String? selectedCity;
  final String? selectedDistrict;
  final String? selectedWard;
  final String address;
  final Gender? valueGender;
  final DegreeType? valueDegree;
  final GradeType? radioGradeTypeValue;
  final String? gradeScore;
  final CertificateType? selectedCertificateType;
  final String? certificateImg;

  const RegisterEvent({
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
    required this.idCardNumber,
    required this.date,
    required this.phone,
    this.selectedSchool,
    this.selectedCountry,
    this.selectedProgram,
    this.selectedCity,
    this.selectedDistrict,
    this.selectedWard,
    required this.address,
    this.valueGender,
    this.valueDegree,
    this.radioGradeTypeValue,
    this.gradeScore,
    this.selectedCertificateType,
    this.certificateImg,
  });

  @override
  List<Object?> get props => [
        email,
        name,
        password,
        confirmPassword,
        idCardNumber,
        date,
        phone,
        selectedSchool,
        selectedCountry,
        selectedProgram,
        selectedCity,
        selectedDistrict,
        selectedWard,
        address,
        valueGender,
        valueDegree,
        radioGradeTypeValue,
        gradeScore,
        selectedCertificateType,
        certificateImg,
      ];
}
