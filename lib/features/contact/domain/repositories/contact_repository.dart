import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/failures/contact_failures.dart';

abstract class ContactRepository {
  Future<Either<ContactFailure, void>> submitContact({
    required String name,
    required String email,
    required String title,
    required String phone,
    required String message,
    String? schoolId,
  });
}
