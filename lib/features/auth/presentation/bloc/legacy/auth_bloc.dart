import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';
import 'package:study_abroad_cemc_mobile/models/country.dart';
import 'package:study_abroad_cemc_mobile/models/user_register.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthLoadingState()) {
    on<CheckEmailEvent>(_onCheckEmail);
    on<CheckPasswordEvent>(_onCheckPassword);
    on<CheckConfirmPasswordEvent>(_onCheckConfirmPassword);
    on<CheckNameEvent>(_onCheckName);
    on<CheckDobEvent>(_onCheckDob);
    on<CheckGenderEvent>(_onCheckGender);
    on<CheckPhoneNumberEvent>(_onCheckPhoneNumber);
    on<CheckIdCardNumberEvent>(_onCheckIdCardNumber);
    on<CheckCityEvent>(_onCheckCity);
    on<CheckDistrictEvent>(_onCheckDistrict);
    on<CheckWardEvent>(_onCheckWard);
    on<CheckAddressEvent>(_onCheckAddress);
    on<CheckSchoolNameEvent>(_onCheckSchoolName);
    on<CheckProgramNameEvent>(_onCheckProgramName);
    on<CheckDegreeTypeEvent>(_onCheckDegreeType);
    on<CheckCertificateTypeEvent>(_onCheckCertificateType);
    on<CheckCertificateImgEvent>(_onCheckCertificateImg);
    on<CheckGradeTypeEvent>(_onCheckGradeType);
    on<CheckGradeScoreEvent>(_onCheckGradeScore);
    on<GetCityEvent>(_onGetCity);
    on<GetSchoolsAndCountriesEvent>(_onGetSchoolsAndCountries);
    on<RegisterEvent>(_onRegister);
  }

  void _onCheckEmail(CheckEmailEvent event, Emitter<AuthState> emit) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(AuthErrorEmailState('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckPassword(CheckPasswordEvent event, Emitter<AuthState> emit) {
    if (event.password.length < 6) {
      emit(AuthErrorPasswordState('Mật khẩu phải lớn hơn 6 ký tự'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckConfirmPassword(
      CheckConfirmPasswordEvent event, Emitter<AuthState> emit) {
    if (event.password != event.confirmPassword) {
      emit(AuthErrorConfrimPasswordState('Mật khẩu không trùng khớp'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckName(CheckNameEvent event, Emitter<AuthState> emit) {
    if (event.name.isEmpty) {
      emit(AuthErrorNameState('Vui lòng nhập họ tên'));
    }
    emit(AuthInitialState());
  }

  void _onCheckDob(CheckDobEvent event, Emitter<AuthState> emit) {
    emit(AuthLoadingState());
    if (event.dob.isAfter(DateTime.now())) {
      emit(AuthErrorDOBState('Date of birth cannot be in the future'));
    } else if (DateTime.now().year - event.dob.year < 18) {
      emit(AuthErrorDOBState('You must be at least 18 years old'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckGender(CheckGenderEvent event, Emitter<AuthState> emit) {
    if (event.gender.isEmpty) {
      emit(AuthErrorGenderErrorState('Vui lòng chọn giới tính'));
    }
  }

  void _onCheckPhoneNumber(
      CheckPhoneNumberEvent event, Emitter<AuthState> emit) {
    if (event.phoneNumber.isEmpty) {
      emit(AuthErrorPhoneState('Vui lòng nhập số điện thoại'));
    } else if (event.phoneNumber.length < 10 ||
        event.phoneNumber.length > 11) {
      emit(AuthErrorPhoneState('Số điện thoại không hợp lệ'));
    }
  }

  void _onCheckIdCardNumber(
      CheckIdCardNumberEvent event, Emitter<AuthState> emit) {
    if (event.idCardNumber.isEmpty) {
      emit(AuthErrorIDCardNumberState('Vui lòng nhập số chứng minh nhân dân'));
    } else if (event.idCardNumber.length <= 9 ||
        event.idCardNumber.length >= 13) {
      emit(AuthErrorIDCardNumberState('Số chứng minh nhân dân không hợp lệ'));
    }
  }

  void _onCheckCity(CheckCityEvent event, Emitter<AuthState> emit) {
    if (event.city.isEmpty) {
      emit(AuthErrorCityState('Vui lòng chọn thành phố'));
    }
  }

  void _onCheckDistrict(CheckDistrictEvent event, Emitter<AuthState> emit) {
    if (event.district.isEmpty) {
      emit(AuthErrorDistrictState('Vui lòng chọn quận/huyện'));
    }
  }

  void _onCheckWard(CheckWardEvent event, Emitter<AuthState> emit) {
    if (event.ward.isEmpty) {
      emit(AuthErrorWardState('Vui lòng chọn phường/xã'));
    }
  }

  void _onCheckAddress(CheckAddressEvent event, Emitter<AuthState> emit) {
    if (event.address.isEmpty) {
      emit(AuthErrorAddressState('Vui lòng nhập địa chỉ'));
    }
  }

  void _onCheckSchoolName(
      CheckSchoolNameEvent event, Emitter<AuthState> emit) {
    if (event.schoolName.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn trường học'));
    }
  }

  void _onCheckProgramName(
      CheckProgramNameEvent event, Emitter<AuthState> emit) {
    if (event.programName.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn chương trình học'));
    }
  }

  void _onCheckDegreeType(
      CheckDegreeTypeEvent event, Emitter<AuthState> emit) {
    if (event.degreeType.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn loại bằng cấp'));
    }
  }

  void _onCheckCertificateType(
      CheckCertificateTypeEvent event, Emitter<AuthState> emit) {
    if (event.certificateType.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn loại chứng chỉ'));
    }
  }

  void _onCheckCertificateImg(
      CheckCertificateImgEvent event, Emitter<AuthState> emit) {
    if (event.certificateImg.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn ảnh chứng chỉ'));
    }
  }

  void _onCheckGradeType(CheckGradeTypeEvent event, Emitter<AuthState> emit) {
    if (event.gradeType.isEmpty) {
      emit(AuthErrorNamedSchoolState('Vui lòng chọn loại điểm'));
    }
  }

  void _onCheckGradeScore(CheckGradeScoreEvent event, Emitter<AuthState> emit) {
    if (event.gradeScore == 0.0) {
      emit(AuthErrorNamedSchoolState('Vui lòng nhập điểm'));
    } else if (event.gradeScore < 0 || event.gradeScore > 10) {
      emit(AuthErrorNamedSchoolState('Điểm không hợp lệ'));
    }
  }

  Future<void> _onGetCity(GetCityEvent event, Emitter<AuthState> emit) async {
    try {
      APIRepository authRepo = APIRepository();
      List<Country> city = await authRepo.fetchCountry();
      emit(AuthLoadedCityState(city));
    } catch (ex) {
      emit(AuthErrorCityState(ex.toString()));
    }
  }

  Future<void> _onGetSchoolsAndCountries(
      GetSchoolsAndCountriesEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      APIRepository authRepo = APIRepository();
      final schools = await authRepo.fetchSchools();
      final countries =
          schools.map((school) => school.country).toSet().toList();
      emit(AuthLoadedState(schools: schools, countries: countries));
    } catch (error) {
      emit(AuthErrorState(error.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    String gradeScoreString = event.gradeScore.toString();
    emit(AuthLoadingState());
    try {
      APIRepository authRepo = APIRepository();
      UserAuthRegister? userAuthRegister = await authRepo.register(
          event.email,
          event.name,
          event.password,
          event.confirmPassword,
          event.idCardNumber,
          event.date,
          event.phone,
          event.selectedSchool,
          event.selectedCountry,
          event.selectedProgram,
          event.selectedCity,
          event.selectedDistrict,
          event.selectedWard!,
          event.address,
          event.valueGender.toString().split('.').last.toUpperCase(),
          event.valueDegree?.toString().split('.').last.toUpperCase(),
          event.radioGradeTypeValue?.toString().split('.').last,
          gradeScoreString,
          event.selectedCertificateType?.toString().split('.').last,
          event.certificateImg);
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
