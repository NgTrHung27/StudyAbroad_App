import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/data/datasources/scholarship_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/data/models/apply_scholar_model.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/failures/scholarship_failures.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/repositories/scholarship_repository.dart';

class ScholarshipRepositoryImpl implements ScholarshipRepository {
  final ScholarshipRemoteDataSource remoteDataSource;

  ScholarshipRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ScholarshipFailure, ApplyScholarModel>> applyScholarship({
    required String url,
    required String studentId,
    required String scholarshipId,
    required String additional,
  }) async {
    try {
      final response = await remoteDataSource.applyScholarship(
        url: url,
        studentId: studentId,
        scholarshipId: scholarshipId,
        additional: additional,
      );

      final model = ApplyScholarModel.fromJson(response);
      return Right(model);
    } on NetworkException {
      return const Left(ScholarshipNetworkFailure());
    } on ServerException catch (e) {
      return Left(ScholarshipServerFailure(e.message, e.statusCode));
    } catch (e) {
      return const Left(ScholarshipUnknownFailure());
    }
  }
}
