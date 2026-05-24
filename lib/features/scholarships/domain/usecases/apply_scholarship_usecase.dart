import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/data/models/apply_scholar_model.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/failures/scholarship_failures.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/repositories/scholarship_repository.dart';

class ApplyScholarshipUseCase {
  final ScholarshipRepository repository;

  ApplyScholarshipUseCase(this.repository);

  Future<Either<ScholarshipFailure, ApplyScholarModel>> call({
    required String url,
    required String studentId,
    required String scholarshipId,
    required String additional,
  }) async {
    return repository.applyScholarship(
      url: url,
      studentId: studentId,
      scholarshipId: scholarshipId,
      additional: additional,
    );
  }
}
