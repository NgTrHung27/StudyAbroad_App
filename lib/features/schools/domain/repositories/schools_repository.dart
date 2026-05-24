import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';

abstract class SchoolsRepository {
  Future<Either<SchoolsFailure, List<SchoolEntity>>> getSchools();
  Future<Either<SchoolsFailure, List<String>>> getUniqueCountries();
  Future<Either<SchoolsFailure, SchoolEntity>> getSchoolById(String id);
}
