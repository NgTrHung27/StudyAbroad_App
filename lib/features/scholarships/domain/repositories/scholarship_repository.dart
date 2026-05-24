import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/data/models/apply_scholar_model.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/failures/scholarship_failures.dart';

abstract class ScholarshipRepository {
  Future<Either<ScholarshipFailure, ApplyScholarModel>> applyScholarship({
    required String url,
    required String studentId,
    required String scholarshipId,
    required String additional,
  });
}
