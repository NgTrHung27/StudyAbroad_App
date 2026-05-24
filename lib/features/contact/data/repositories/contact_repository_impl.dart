import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/contact/data/datasources/contact_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/failures/contact_failures.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ContactFailure, void>> submitContact({
    required String name,
    required String email,
    required String title,
    required String phone,
    required String message,
    String? schoolId,
  }) async {
    try {
      await remoteDataSource.submitContact(
        name: name,
        email: email,
        title: title,
        phone: phone,
        message: message,
        schoolId: schoolId,
      );
      return const Right(null);
    } on NetworkException {
      return const Left(ContactNetworkFailure());
    } on ServerException catch (e) {
      return Left(ContactServerFailure(e.message, e.statusCode));
    } catch (e) {
      return const Left(ContactUnknownFailure());
    }
  }
}
