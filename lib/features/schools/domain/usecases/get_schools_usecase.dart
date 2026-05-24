import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/schools_repository.dart';

class GetSchoolsUseCase {
  final SchoolsRepository repository;

  GetSchoolsUseCase(this.repository);

  Future<Either<SchoolsFailure, List<SchoolEntity>>> call() async {
    return repository.getSchools();
  }
}
