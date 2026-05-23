import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/school_repository.dart';
import 'school_event.dart';
import 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository _repository;

  SchoolBloc({required SchoolRepository repository})
      : _repository = repository,
        super(SchoolsInitial()) {
    on<GetSchoolListEvent>(_onGetSchoolList);
    on<GetSchoolListByCountryEvent>(_onGetSchoolListByCountry);
    on<GetUniqueCountriesEvent>(_onGetUniqueCountries);
  }

  Future<void> _onGetSchoolList(
    GetSchoolListEvent event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolsLoading());
    final result = await _repository.getSchools();
    result.fold(
      (failure) =>
          emit(SchoolsError(message: failure.message, failure: failure)),
      (schools) => emit(SchoolsLoaded(schoolList: schools)),
    );
  }

  Future<void> _onGetSchoolListByCountry(
    GetSchoolListByCountryEvent event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolsLoading());
    final result = await _repository.getSchools();
    result.fold(
      (failure) =>
          emit(SchoolsError(message: failure.message, failure: failure)),
      (schools) {
        final filteredList =
            schools.where((school) => school.country == event.country).toList();
        emit(SchoolsLoaded(schoolList: filteredList));
      },
    );
  }

  Future<void> _onGetUniqueCountries(
    GetUniqueCountriesEvent event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolsLoading());
    final result = await _repository.getUniqueCountries();
    result.fold(
      (failure) =>
          emit(SchoolsError(message: failure.message, failure: failure)),
      (countries) => emit(UniqueCountriesLoaded(countries)),
    );
  }
}
