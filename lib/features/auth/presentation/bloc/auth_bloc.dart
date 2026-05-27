import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_schools_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_unique_countries_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:study_abroad_cemc_mobile/models/enum.dart';
import 'package:study_abroad_cemc_mobile/models/country.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/get_countries_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final GetSchoolsUseCase getSchoolsUseCase;
  final GetUniqueCountriesUseCase getUniqueCountriesUseCase;
  final GetCountriesUseCase getCountriesUseCase;

  AuthBloc({
    RegisterUseCase? registerUseCase,
    GetSchoolsUseCase? getSchoolsUseCase,
    GetUniqueCountriesUseCase? getUniqueCountriesUseCase,
    GetCountriesUseCase? getCountriesUseCase,
  })  : registerUseCase = registerUseCase ?? getIt<RegisterUseCase>(),
        getSchoolsUseCase = getSchoolsUseCase ?? getIt<GetSchoolsUseCase>(),
        getUniqueCountriesUseCase =
            getUniqueCountriesUseCase ?? getIt<GetUniqueCountriesUseCase>(),
        getCountriesUseCase =
            getCountriesUseCase ?? getIt<GetCountriesUseCase>(),
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
      emit(AuthErrorEmailState(errorInvalidEmailKey.tr()));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckPassword(CheckPasswordEvent event, Emitter<AuthState> emit) {
    if (event.password.length < 6) {
      emit(AuthErrorPasswordState(errorShortPasswordKey.tr()));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckConfirmPassword(
      CheckConfirmPasswordEvent event, Emitter<AuthState> emit) {
    if (event.password != event.confirmPassword) {
      emit(AuthErrorConfrimPasswordState(errorPasswordMismatchKey.tr()));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckName(CheckNameEvent event, Emitter<AuthState> emit) {
    if (event.name.isEmpty) {
      emit(AuthErrorNameState(errorEmptyNameKey.tr()));
    }
    emit(AuthInitialState());
  }

  void _onCheckDob(CheckDobEvent event, Emitter<AuthState> emit) {
    emit(AuthLoadingState());
    if (event.dob.isAfter(DateTime.now())) {
      emit(AuthErrorDOBState(errorFutureDobKey.tr()));
    } else if (DateTime.now().year - event.dob.year < 18) {
      emit(AuthErrorDOBState(errorUnderageDobKey.tr()));
    } else {
      emit(AuthInitialState());
    }
  }

  void _onCheckGender(CheckGenderEvent event, Emitter<AuthState> emit) {
    if (event.gender.isEmpty) {
      emit(AuthErrorGenderErrorState(errorEmptyGenderKey.tr()));
    }
  }

  void _onCheckPhoneNumber(
      CheckPhoneNumberEvent event, Emitter<AuthState> emit) {
    if (event.phoneNumber.isEmpty) {
      emit(AuthErrorPhoneState(errorEmptyPhoneKey.tr()));
    } else if (event.phoneNumber.length < 10 || event.phoneNumber.length > 11) {
      emit(AuthErrorPhoneState(errorInvalidPhoneKey.tr()));
    }
  }

  void _onCheckIdCardNumber(
      CheckIdCardNumberEvent event, Emitter<AuthState> emit) {
    if (event.idCardNumber.isEmpty) {
      emit(AuthErrorIDCardNumberState(errorEmptyIdCardKey.tr()));
    } else if (event.idCardNumber.length <= 9 ||
        event.idCardNumber.length >= 13) {
      emit(AuthErrorIDCardNumberState(errorInvalidIdCardKey.tr()));
    }
  }

  void _onCheckDistrict(CheckDistrictEvent event, Emitter<AuthState> emit) {
    if (event.district.isEmpty) {
      emit(AuthErrorDistrictState(errorEmptyDistrictKey.tr()));
    }
  }

  void _onCheckWard(CheckWardEvent event, Emitter<AuthState> emit) {
    if (event.ward.isEmpty) {
      emit(AuthErrorWardState(errorEmptyWardKey.tr()));
    }
  }

  void _onCheckAddress(CheckAddressEvent event, Emitter<AuthState> emit) {
    if (event.address.isEmpty) {
      emit(AuthErrorAddressState(errorEmptyAddressKey.tr()));
    }
  }

  void _onCheckSchoolName(CheckSchoolNameEvent event, Emitter<AuthState> emit) {
    if (event.schoolName.isEmpty) {
      emit(AuthErrorNamedSchoolState(errorEmptySchoolKey.tr()));
    }
  }

  void _onCheckProgramName(
      CheckProgramNameEvent event, Emitter<AuthState> emit) {
    if (event.programName.isEmpty) {
      emit(AuthErrorNamedSchoolState(errorEmptyProgramKey.tr()));
    }
  }

  void _onCheckDegreeType(CheckDegreeTypeEvent event, Emitter<AuthState> emit) {
    if (event.degreeType.isEmpty) {
      emit(AuthErrorNamedSchoolState(errorEmptyDegreeTypeKey.tr()));
    }
  }

  void _onCheckCertificateType(
      CheckCertificateTypeEvent event, Emitter<AuthState> emit) {
    if (event.certificateType.isEmpty) {
      emit(AuthErrorNamedSchoolState(errorEmptyCertificateTypeKey.tr()));
    }
  }

  void _onCheckCertificateImg(
      CheckCertificateImgEvent event, Emitter<AuthState> emit) {
    if (event.certificateImg.isEmpty) {
      emit(AuthErrorNamedSchoolState(errorEmptyCertificateImgKey.tr()));
    }
  }

  void _onCheckGradeType(CheckGradeTypeEvent event, Emitter<AuthState> emit) {
    if (event.gradeType.isEmpty) {
      emit(AuthErrorNamedSchoolState(errorEmptyGradeTypeKey.tr()));
    }
  }

  void _onCheckGradeScore(CheckGradeScoreEvent event, Emitter<AuthState> emit) {
    if (event.gradeScore == 0.0) {
      emit(AuthErrorNamedSchoolState(errorEmptyGradeScoreKey.tr()));
    } else if (event.gradeScore < 0 || event.gradeScore > 10) {
      emit(AuthErrorNamedSchoolState(errorEmptyGradeScoreKey.tr()));
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
    final result = await getCountriesUseCase();
    result.fold(
      (failure) {
        emit(AuthErrorCityState(failure.message));
      },
      (countries) {
        emit(AuthLoadedCityState(const [], country: countries));
      },
    );
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
      city: event.selectedCity,
      district: event.selectedDistrict,
      ward: event.selectedWard,
      addressLine: event.address,
      gender: event.valueGender?.toString().split('.').last.toUpperCase(),
      degreeType: event.valueDegree?.toString().split('.').last.toUpperCase(),
      gradeType: event.radioGradeTypeValue?.toString().split('.').last,
      gradeScore: gradeScoreString,
      certificateType:
          event.selectedCertificateType?.toString().split('.').last,
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
      (user) => emit(AuthSuccessState(user)),
    );
  }
}
