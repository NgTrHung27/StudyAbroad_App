import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_schools_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_unique_countries_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:study_abroad_cemc_mobile/models/enum.dart';
import 'package:study_abroad_cemc_mobile/models/user_register.dart';
import 'package:study_abroad_cemc_mobile/models/country.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final GetSchoolsUseCase getSchoolsUseCase;
  final GetUniqueCountriesUseCase getUniqueCountriesUseCase;

  AuthBloc({
    RegisterUseCase? registerUseCase,
    GetSchoolsUseCase? getSchoolsUseCase,
    GetUniqueCountriesUseCase? getUniqueCountriesUseCase,
  })  : registerUseCase = registerUseCase ?? getIt<RegisterUseCase>(),
        getSchoolsUseCase = getSchoolsUseCase ?? getIt<GetSchoolsUseCase>(),
        getUniqueCountriesUseCase = getUniqueCountriesUseCase ?? getIt<GetUniqueCountriesUseCase>(),
        super(AuthInitialState()) {
    on<CheckEmailEvent>(_onCheckEmail);
    on<CheckPasswordEvent>(_onCheckPassword);
    on<CheckConfirmPasswordEvent>(_onCheckConfirmPassword);
    on<CheckNameEvent>(_onCheckName);
    on<CheckDobEvent>(_onCheckDob);
    on<CheckGenderEvent>(_onCheckGender);
    on<CheckPhoneNumberEvent>(_onCheckPhoneNumber);
    on<CheckIdCardNumberEvent>(_onCheckIdCardNumber);
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
    on<GetSchoolsAndCountriesEvent>(_onGetSchoolsAndCountries);
    on<GetCityEvent>(_onGetCity);
    on<RegisterEvent>(_onRegister);
  }

  void _onCheckEmail(CheckEmailEvent event, Emitter<AuthState> emit) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(const AuthErrorEmailState('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckPassword(CheckPasswordEvent event, Emitter<AuthState> emit) {
    if (event.password.length < 6) {
      emit(const AuthErrorPasswordState('Mật khẩu phải lớn hơn 6 ký tự'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckConfirmPassword(
      CheckConfirmPasswordEvent event, Emitter<AuthState> emit) {
    if (event.password != event.confirmPassword) {
      emit(const AuthErrorConfrimPasswordState('Mật khẩu không trùng khớp'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckName(CheckNameEvent event, Emitter<AuthState> emit) {
    if (event.name.isEmpty) {
      emit(const AuthErrorNameState('Vui lòng nhập họ tên'));
    }
    emit(AuthInitialState());
  }

  void _onCheckDob(CheckDobEvent event, Emitter<AuthState> emit) {
    emit(AuthLoadingState());
    if (event.dob.isAfter(DateTime.now())) {
      emit(const AuthErrorDOBState('Date of birth cannot be in the future'));
    } else if (DateTime.now().year - event.dob.year < 18) {
      emit(const AuthErrorDOBState('You must be at least 18 years old'));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckGender(CheckGenderEvent event, Emitter<AuthState> emit) {
    if (event.gender.isEmpty) {
      emit(const AuthErrorGenderErrorState('Vui lòng chọn giới tính'));
    }
  }

  void _onCheckPhoneNumber(
      CheckPhoneNumberEvent event, Emitter<AuthState> emit) {
    if (event.phoneNumber.isEmpty) {
      emit(const AuthErrorPhoneState('Vui lòng nhập số điện thoại'));
    } else if (event.phoneNumber.length < 10 || event.phoneNumber.length > 11) {
      emit(const AuthErrorPhoneState('Số điện thoại không hợp lệ'));
    }
  }

  void _onCheckIdCardNumber(
      CheckIdCardNumberEvent event, Emitter<AuthState> emit) {
    if (event.idCardNumber.isEmpty) {
      emit(const AuthErrorIDCardNumberState('Vui lòng nhập số chứng minh nhân dân'));
    } else if (event.idCardNumber.length <= 9 ||
        event.idCardNumber.length >= 13) {
      emit(const AuthErrorIDCardNumberState('Số chứng minh nhân dân không hợp lệ'));
    }
  }

  void _onCheckDistrict(CheckDistrictEvent event, Emitter<AuthState> emit) {
    if (event.district.isEmpty) {
      emit(const AuthErrorDistrictState('Vui lòng chọn quận/huyện'));
    }
  }

  void _onCheckWard(CheckWardEvent event, Emitter<AuthState> emit) {
    if (event.ward.isEmpty) {
      emit(const AuthErrorWardState('Vui lòng chọn phường/xã'));
    }
  }

  void _onCheckAddress(CheckAddressEvent event, Emitter<AuthState> emit) {
    if (event.address.isEmpty) {
      emit(const AuthErrorAddressState('Vui lòng nhập địa chỉ'));
    }
  }

  void _onCheckSchoolName(CheckSchoolNameEvent event, Emitter<AuthState> emit) {
    if (event.schoolName.isEmpty) {
      emit(const AuthErrorNamedSchoolState('Vui lòng chọn trường học'));
    }
  }

  void _onCheckProgramName(
      CheckProgramNameEvent event, Emitter<AuthState> emit) {
    if (event.programName.isEmpty) {
      emit(const AuthErrorNamedSchoolState('Vui lòng chọn chương trình học'));
    }
  }

  void _onCheckDegreeType(CheckDegreeTypeEvent event, Emitter<AuthState> emit) {
    if (event.degreeType.isEmpty) {
      emit(const AuthErrorNamedSchoolState('Vui lòng chọn loại bằng cấp'));
    }
  }

  void _onCheckCertificateType(
      CheckCertificateTypeEvent event, Emitter<AuthState> emit) {
    if (event.certificateType.isEmpty) {
      emit(const AuthErrorNamedSchoolState('Vui lòng chọn loại chứng chỉ'));
    }
  }

  void _onCheckCertificateImg(
      CheckCertificateImgEvent event, Emitter<AuthState> emit) {
    if (event.certificateImg.isEmpty) {
      emit(const AuthErrorNamedSchoolState('Vui lòng chọn ảnh chứng chỉ'));
    }
  }

  void _onCheckGradeType(CheckGradeTypeEvent event, Emitter<AuthState> emit) {
    if (event.gradeType.isEmpty) {
      emit(const AuthErrorNamedSchoolState('Vui lòng chọn loại điểm'));
    }
  }

  void _onCheckGradeScore(CheckGradeScoreEvent event, Emitter<AuthState> emit) {
    if (event.gradeScore == 0.0) {
      emit(const AuthErrorNamedSchoolState('Vui lòng nhập điểm'));
    } else if (event.gradeScore < 0 || event.gradeScore > 10) {
      emit(const AuthErrorNamedSchoolState('Điểm không hợp lệ'));
    }
  }

  Future<void> _onGetSchoolsAndCountries(
      GetSchoolsAndCountriesEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final schoolsResult = await getSchoolsUseCase();

    await schoolsResult.fold(
      (failure) async {
        if (failure is NetworkErrorFailure) {
          emit(const AuthErrorState(
            'No internet connection. Please check your network.',
            isNetworkError: true,
          ));
        } else {
          emit(AuthErrorState(failure.message ?? 'An error occurred'));
        }
      },
      (schools) async {
        final countries = schools
            .map((school) => school.country)
            .where((c) => c.isNotEmpty)
            .toSet()
            .toList();
        emit(AuthLoadedState(schools: schools, countries: countries));
      },
    );
  }

  Future<void> _onGetCity(GetCityEvent event, Emitter<AuthState> emit) async {
    try {
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json'));
      if (response.statusCode == 200) {
        final List<Country> countries = countryFromJson(response.body);
        emit(AuthLoadedCityState(const [], country: countries));
      } else {
        emit(const AuthErrorCityState('Failed to load city data'));
      }
    } catch (e) {
      emit(AuthErrorCityState(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    String gradeScoreString = event.gradeScore ?? '0.0';
    emit(AuthLoadingState());

    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      name: event.name,
      phoneNumber: event.phone,
      idCardNumber: event.idCardNumber,
      dob: event.date,
      schoolName: event.selectedSchool,
      country: event.selectedCountry,
      programName: event.selectedProgram,
      addressLine: '${event.selectedWard ?? ''}, ${event.selectedDistrict ?? ''}, ${event.selectedCity ?? ''}, ${event.address}',
      gender: event.valueGender?.toString().split('.').last.toUpperCase(),
      degreeType: event.valueDegree?.toString().split('.').last.toUpperCase(),
      gradeType: event.radioGradeTypeValue?.toString().split('.').last,
      gradeScore: gradeScoreString,
      certificateType: event.selectedCertificateType?.toString().split('.').last,
      certificateImg: event.certificateImg,
    );

    result.fold(
      (failure) {
        if (failure is NetworkErrorFailure) {
          emit(const AuthErrorState(
            'No internet connection. Please check your network.',
            isNetworkError: true,
          ));
        } else if (failure is ValidationErrorFailure) {
          emit(AuthErrorState(failure.message));
        } else {
          emit(AuthErrorState(failure.message));
        }
      },
      (user) => emit(AuthSuccessState(user as dynamic)),
    );
  }
}
