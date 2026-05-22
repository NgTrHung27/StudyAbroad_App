import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/school_failures.dart';

abstract class SchoolRepository {
  /// Fetch all schools
  Future<Either<SchoolFailure, List<SchoolEntity>>> getSchools();
  
  /// Fetch unique countries from schools
  Future<Either<SchoolFailure, List<String>>> getUniqueCountries();
}
