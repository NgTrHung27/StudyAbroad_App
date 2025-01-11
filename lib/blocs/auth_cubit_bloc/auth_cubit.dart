import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/auth_cubit_bloc/auth_state.dart';
import 'package:kltn_mobile/blocs/repository/repository.dart';
import 'package:kltn_mobile/models/country.dart';
import 'package:kltn_mobile/models/enum.dart';
import 'package:kltn_mobile/models/user_register.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoadingState());
  APIRepository authRepo = APIRepository();

  //check email
  void checkEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(email)) {
      emit(AuthErrorEmailState('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(AuthInitialState());
    }
  }

  //check password
  void checkPassword(String password) {
    if (password.length < 6) {
      emit(AuthErrorPasswordState('Mật khẩu phải lớn hơn 6 ký tự'));
    } else {
      emit(AuthInitialState());
    }
  }

  //check confirm password
  void checkConfrimPassword(String password, String confrimPassword) {
    if (password != confrimPassword) {
      emit(AuthErrorConfrimPasswordState('Mật khẩu không trùng khớp'));
    } else {
      emit(AuthInitialState());
    }
  }

  //check name
  void checkName(String name) {
    if (name.isEmpty) {
      emit(AuthErrorNameState('Vui lòng nhập họ tên'));
    }
    emit(AuthInitialState());
  }

  //check dob
  void checkDob(DateTime dob) {
    emit(AuthLoadingState());
    if (dob.isAfter(DateTime.now())) {
      emit(AuthErrorDOBState('Date of birth cannot be in the future'));
    } else if (DateTime.now().year - dob.year < 18) {
      emit(AuthErrorDOBState('You must be at least 18 years old'));
    } else {
      emit(AuthInitialState());
    }
  }

  //check gender
  void checkGender(String gender) {
    if (gender.isEmpty) {
      emit(AuthErrorGenderErrorState('Vui lòng chọn giới tính'));
    }
  }

  //check phoneNumber
  void checkPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      emit(AuthErrorPhoneState('Vui lòng nhập số điện thoại'));
    } else if (phoneNumber.length < 10 || phoneNumber.length > 11) {
      emit(AuthErrorPhoneState('Số điện thoại không hợp lệ'));
    }
  }

  //check idCardNumber
  void checkIDCardNumber(String idCardNumber) {
    if (idCardNumber.isEmpty) {
      emit(AuthErrorIDCardNumberState('Vui lòng nhập số chứng minh nhân dân'));
    } else if (idCardNumber.length <= 9 || idCardNumber.length >= 13) {
      emit(AuthErrorIDCardNumberState('Số chứng minh nhân dân không hợp lệ'));
    }
  }

  //check city
  void checkCity(String city) {
    if (city.isEmpty) {
      emit(AuthErrorCityState('Vui lòng chọn thành phố'));
    }
  }

  //check district
  void checkDistrict(String district) {
    if (district.isEmpty) {
      emit(AuthErrorDistrictState('Vui lòng chọn quận/huyện'));
    }
  }

  //check ward
  void checkWard(String ward) {
    if (ward.isEmpty) {
      emit(AuthErrorWardState('Vui lòng chọn phường/xã'));
    }
  }

  //check address
  void checkAddress(String address) {
    if (address.isEmpty) {
      emit(AuthErrorAddressState('Vui lòng nhập địa chỉ'));
    }
  }

  //check schoolName
  void checkSchoolName(String schoolName) {
    if (schoolName.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn trường học'));
    }
  }

  //check programName
  void checkProgramName(String programName) {
    if (programName.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn chương trình học'));
    }
  }

  //check degreeType
  void checkDegreeType(String degreeType) {
    if (degreeType.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn loại bằng cấp'));
    }
  }

  //check certificateType
  void checkCertificateType(String certificateType) {
    if (certificateType.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn loại chứng chỉ'));
    }
  }

  //check certificateImg
  void checkCertificateImg(String certificateImg) {
    if (certificateImg.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn ảnh chứng chỉ'));
    }
  }

  //check gradeType
  void checkGradeType(String gradeType) {
    if (gradeType.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn loại điểm'));
    }
  }

  //check gradeScore\
  void checkGradeScore(double gradeScore) {
    if (gradeScore == 0.0) {
      emit(AuthErrorNamedSchoolState('Vui lòng nhập điểm'));
    } else if (gradeScore < 0 || gradeScore > 10) {
      emit(AuthErrorNamedSchoolState('Điểm không hợp lệ'));
    }
  }

  //-----------------------------------
  //fetdata from api
  void getCity() async {
    try {
      List<Country> city = await authRepo.fetchCountry();
      emit(AuthLoadedCityState(city));
    } catch (ex) {
      emit(AuthErrorCityState(ex.toString()));
    }
  }

  Future<void> getSchoolsAndCountries() async {
    try {
      emit(AuthLoadingState());
      final schools = await authRepo.fetchSchools();
      final countries =
          schools.map((school) => school.country).toSet().toList();
      emit(AuthLoadedState(schools: schools, countries: countries));
    } catch (error) {
      emit(AuthErrorState(error.toString()));
    }
  }

  //---------------------------------
  final usermailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final idCardNumberController = TextEditingController();
  final dateController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = DropdownButtonFormField;
  final cityController = DropdownButtonFormField;
  final districtController = DropdownButtonFormField;
  final wardController = DropdownButtonFormField;
  final addressController = TextEditingController();
  final schoolController = DropdownButtonFormField;
  final programController = DropdownButtonFormField;
  final degreeController = DropdownButtonFormField;
  final certificateController = DropdownButtonFormField;
  final gradeTypecontroller = DropdownButtonFormField;
  final gradeController = TextEditingController();
  final certificateTypeController = RadioListTile;
  TextEditingController imageController = TextEditingController();
  //Register
  Future<void> register(
    String email,
    String name,
    String password,
    String confirmpassword,
    String idCardNumber,
    DateTime date,
    String phone,
    String? selectedSchool,
    String? selectedCountry,
    String? selectedProgram,
    String? selectedCity,
    String? selectedDistrict,
    String? selectedWard,
    String address,
    Gender? valueGender,
    DegreeType? valueDegree,
    GradeType? radioGradeTypeValue,
    String? gradeScore,
    CertificateType? selectedCertificateType,
    String? certificateImg,
  ) async {
    String gradeScoreString = gradeScore.toString();
    emit(AuthLoadingState());
    try {
      UserAuthRegister? userAuthRegister = await authRepo.register(
          email,
          name,
          password,
          confirmpassword,
          idCardNumber,
          date,
          phone,
          selectedSchool,
          selectedCountry,
          selectedProgram,
          selectedCity,
          selectedDistrict,
          selectedWard!,
          address,
          valueGender.toString().split('.').last.toUpperCase(),
          valueDegree?.toString().split('.').last.toUpperCase(),
          radioGradeTypeValue?.toString().split('.').last,
          gradeScoreString,
          selectedCertificateType?.toString().split('.').last,
          certificateImg);
      // ignore: unnecessary_null_comparison
      if (userAuthRegister != null && userAuthRegister.error == null) {
        emit(AuthSuccessState(userAuthRegister));
      } else if (userAuthRegister?.error != null) {
        emit(AuthErrorState(userAuthRegister?.error ?? 'Failed to register'));
      } else {
        emit(AuthErrorState('Failed to register'));
      }
    } catch (ex) {
      emit(AuthErrorState(ex.toString()));
    }
  }
}
