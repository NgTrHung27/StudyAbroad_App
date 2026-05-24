import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/schools_repository.dart';

class GetSchoolByIdUseCase {
  final SchoolsRepository repository;

  GetSchoolByIdUseCase(this.repository);

  Future<Either<SchoolsFailure, SchoolEntity>> call(String schoolId) async {
    return repository.getSchoolById(schoolId);
  }
}
