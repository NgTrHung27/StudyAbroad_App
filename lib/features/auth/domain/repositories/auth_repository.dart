import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';

/// Abstract repository interface for authentication
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Register new account
  Future<Either<AuthFailure, UserEntity>> register({
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
    String? addressLine,
    String? gender,
    String? degreeType,
    String? gradeType,
    String? gradeScore,
    String? certificateType,
    String? certificateImg,
  });

  /// Logout current user
  Future<Either<AuthFailure, void>> logout();

  /// Check if user is logged in
  Future<Either<AuthFailure, bool>> isLoggedIn();

  /// Get current user from cache
  Future<Either<AuthFailure, UserEntity?>> getCachedUser();

  /// Get current user profile from server
  Future<Either<AuthFailure, UserEntity>> getCurrentProfile();

  /// Refresh token
  Future<Either<AuthFailure, String>> refreshToken();

  /// Forgot password - request reset email
  Future<Either<AuthFailure, void>> forgotPassword(String email);

  /// Change password
  Future<Either<AuthFailure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });

  /// Verify email
  Future<Either<AuthFailure, void>> verifyEmail(String token);

  /// Delete account
  Future<Either<AuthFailure, void>> deleteAccount();
}
