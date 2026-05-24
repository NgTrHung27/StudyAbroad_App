import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/failures/contact_failures.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/repositories/contact_repository.dart';

class SubmitContactUseCase {
  final ContactRepository repository;

  SubmitContactUseCase(this.repository);

  Future<Either<ContactFailure, void>> call({
    required String name,
    required String email,
    required String title,
    required String phone,
    required String message,
    String? schoolId,
  }) async {
    return repository.submitContact(
      name: name,
      email: email,
      title: title,
      phone: phone,
      message: message,
      schoolId: schoolId,
    );
  }
}
