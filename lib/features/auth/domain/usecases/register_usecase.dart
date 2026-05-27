import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<AuthFailure, UserEntity>> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phoneNumber,
    required String idCardNumber,
    required DateTime dob,
    String? schoolName,
    String? country,
    String? programName,
    String? city,
    String? district,
    String? ward,
    String? addressLine,
    String? gender,
    String? degreeType,
    String? gradeType,
    String? gradeScore,
    String? certificateType,
    String? certificateImg,
  }) async {
    return repository.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
      phoneNumber: phoneNumber,
      idCardNumber: idCardNumber,
      dob: dob,
      schoolName: schoolName,
      country: country,
      programName: programName,
      city: city,
      district: district,
      ward: ward,
      addressLine: addressLine,
      gender: gender,
      degreeType: degreeType,
      gradeType: gradeType,
      gradeScore: gradeScore,
      certificateType: certificateType,
      certificateImg: certificateImg,
    );
  }
}
