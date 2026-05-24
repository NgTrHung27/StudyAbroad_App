import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_schools_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_school_by_id_usecase.dart';
import 'school_event.dart';
import 'school_state.dart';

class SchoolsBloc extends Bloc<SchoolEvent, SchoolState> {
  final GetSchoolsUseCase getSchoolsUseCase;
  final GetSchoolByIdUseCase getSchoolByIdUseCase;

  SchoolsBloc({
    required this.getSchoolsUseCase,
    required this.getSchoolByIdUseCase,
  }) : super(SchoolsInitial()) {
    on<GetSchoolListEvent>(_onGetSchoolList);
    on<GetSchoolListByCountryEvent>(_onGetSchoolListByCountry);
    on<GetSchoolByIdEvent>(_onGetSchoolById);
  }

  Future<void> _onGetSchoolList(
    GetSchoolListEvent event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolsLoading());
    final result = await getSchoolsUseCase();
    result.fold(
      (failure) => emit(SchoolsError(
        message: _mapFailureToMessage(failure),
        failure: failure,
      )),
      (schools) => emit(SchoolsLoaded(schoolList: schools)),
    );
  }

  Future<void> _onGetSchoolListByCountry(
    GetSchoolListByCountryEvent event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolsLoading());
    final result = await getSchoolsUseCase();
    result.fold(
      (failure) => emit(SchoolsError(
        message: _mapFailureToMessage(failure),
        failure: failure,
      )),
      (schools) {
        final filteredList =
            schools.where((school) => school.country == event.country).toList();
        emit(SchoolsLoaded(schoolList: filteredList));
      },
    );
  }

  Future<void> _onGetSchoolById(
    GetSchoolByIdEvent event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolsLoading());
    final result = await getSchoolByIdUseCase(event.schoolId);
    result.fold(
      (failure) => emit(SchoolsError(
        message: _mapFailureToMessage(failure),
        failure: failure,
      )),
      (school) => emit(SchoolDetailLoaded(school: school)),
    );
  }

  String _mapFailureToMessage(SchoolsFailure failure) {
    if (failure is SchoolsNetworkFailure) {
      return 'Unable to connect to the server. Please check your internet connection.';
    }
    if (failure is SchoolsNotFoundFailure) {
      return 'Schools not found.';
    }
    if (failure is SchoolsParseFailure) {
      return 'Failed to load data. Please try again.';
    }
    return failure.message ?? 'An error occurred. Please try again.';
  }
}
