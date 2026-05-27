import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_abroad_cemc_mobile/models/country.dart';

class GetCountriesUseCase {
  final AuthRepository repository;

  GetCountriesUseCase(this.repository);

  Future<Either<AuthFailure, List<Country>>> call() async {
    return await repository.getCountries();
  }
}
