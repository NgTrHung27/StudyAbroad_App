import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/schools_repository.dart';

class GetUniqueCountriesUseCase {
  final SchoolsRepository repository;

  GetUniqueCountriesUseCase(this.repository);

  Future<Either<SchoolsFailure, List<String>>> call() async {
    return repository.getUniqueCountries();
  }
}
