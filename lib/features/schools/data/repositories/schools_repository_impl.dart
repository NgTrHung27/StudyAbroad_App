import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/schools/data/datasources/schools_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/schools_repository.dart';

class SchoolsRepositoryImpl implements SchoolsRepository {
  final SchoolsRemoteDataSource remoteDataSource;

  SchoolsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<SchoolsFailure, List<SchoolEntity>>> getSchools() async {
    try {
      final schools = await remoteDataSource.getSchools();
      return Right(schools);
    } on NetworkException catch (e) {
      return Left(SchoolsNetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(SchoolsServerFailure(e.message));
    } on ParseException catch (e) {
      return Left(SchoolsParseFailure(e.message));
    } catch (e) {
      return Left(SchoolsServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<SchoolsFailure, List<String>>> getUniqueCountries() async {
    try {
      final countries = await remoteDataSource.getUniqueCountries();
      return Right(countries);
    } on NetworkException catch (e) {
      return Left(SchoolsNetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(SchoolsServerFailure(e.message));
    } catch (e) {
      return Left(SchoolsServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<SchoolsFailure, SchoolEntity>> getSchoolById(String id) async {
    try {
      final school = await remoteDataSource.getSchoolById(id);
      return Right(school);
    } on NetworkException catch (e) {
      return Left(SchoolsNetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(SchoolsServerFailure(e.message));
    } on ParseException catch (e) {
      return Left(SchoolsParseFailure(e.message));
    } catch (e) {
      return Left(SchoolsServerFailure(e.toString()));
    }
  }
}
