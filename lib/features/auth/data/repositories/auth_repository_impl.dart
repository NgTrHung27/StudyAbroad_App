import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/cache/local_storage.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/auth/data/models/user_model.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using Either for error handling
class AuthRepositoryImpl implements AuthRepository {
  final http.Client _client;

  AuthRepositoryImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiUrls.login),
        headers: {'Content-Type': 'application/json'},
        body: utf8.encode(jsonEncode({
          'email': email,
          'password': password,
        })),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = data['data']['token'];
        final refreshToken = data['data']['refreshToken'];

        // Save tokens
        await LocalStorage.setString(StorageKeys.token, token);
        if (refreshToken != null) {
          await LocalStorage.setString(StorageKeys.refreshToken, refreshToken);
        }

        // Fetch User Profile
        final meResponse = await _client.get(
          Uri.parse(ApiUrls.currentProfile),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (meResponse.statusCode == 200) {
          final meData = jsonDecode(utf8.decode(meResponse.bodyBytes));
          final user = UserModel.fromJson(meData['data']);

          await _saveUserToCache(user, email, password);
          return Right(user);
        } else {
          return Left(ServerErrorFailure(meResponse.statusCode));
        }
      } else if (response.statusCode == 401) {
        return Left(InvalidCredentialsFailure());
      } else {
        return Left(ServerErrorFailure(response.statusCode));
      }
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } on NetworkException {
      return Left(const NetworkErrorFailure());
    } catch (e) {
      return Left(const UnknownErrorFailure());
    }
  }

  @override
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
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'name': name,
        'phoneNumber': phoneNumber,
        'idCardNumber': idCardNumber,
        'dob': dob.toIso8601String(),
        if (schoolName != null) 'schoolName': schoolName,
        if (country != null) 'country': country,
        if (programName != null) 'programName': programName,
        if (addressLine != null) 'addressLine': addressLine,
        if (gender != null) 'gender': gender,
        if (degreeType != null) 'degreeType': degreeType,
        if (gradeType != null) 'gradeType': gradeType,
        if (gradeScore != null) 'gradeScore': gradeScore,
        if (certificateType != null) 'certificateType': certificateType,
        if (certificateImg != null) 'certificateImg': certificateImg,
      };

      final response = await _client.post(
        Uri.parse(ApiUrls.register),
        headers: {'Content-Type': 'application/json'},
        body: utf8.encode(jsonEncode(body)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final user = UserModel.fromJson(data);
        return Right(user);
      } else if (response.statusCode == 406) {
        return Left(ValidationErrorFailure());
      } else {
        return Left(ServerErrorFailure(response.statusCode));
      }
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } on NetworkException {
      return Left(const NetworkErrorFailure());
    } catch (e) {
      return Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      // Clear local storage
      await LocalStorage.remove(StorageKeys.token);
      await LocalStorage.remove(StorageKeys.user);
      await LocalStorage.remove(StorageKeys.userEmail);
      await LocalStorage.remove(StorageKeys.userPassword);

      return const Right(null);
    } catch (e) {
      return Left(const UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, bool>> isLoggedIn() async {
    try {
      final token = LocalStorage.getString(StorageKeys.token);
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity?>> getCachedUser() async {
    try {
      final userJson = LocalStorage.getJson(StorageKeys.user);
      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        return Right(user);
      }
      return const Right(null);
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<AuthFailure, String>> refreshToken() async {
    // TODO: Implement token refresh if needed
    return const Left(UnknownErrorFailure());
  }

  @override
  Future<Either<AuthFailure, void>> forgotPassword(String email) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiUrls.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: utf8.encode(jsonEncode({'email': email})),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerErrorFailure(response.statusCode));
      }
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } on NetworkException {
      return Left(const NetworkErrorFailure());
    } catch (e) {
      return Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiUrls.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: utf8.encode(jsonEncode({
          'email': email,
        })),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerErrorFailure(response.statusCode));
      }
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } on NetworkException {
      return Left(const NetworkErrorFailure());
    } catch (e) {
      return Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> verifyEmail(String token) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiUrls.emailVerification),
        headers: {'Content-Type': 'application/json'},
        body: utf8.encode(jsonEncode({'token': token})),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerErrorFailure(response.statusCode));
      }
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } on NetworkException {
      return Left(const NetworkErrorFailure());
    } catch (e) {
      return Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> deleteAccount() async {
    try {
      final token = LocalStorage.getString(StorageKeys.token);

      final response = await _client.delete(
        Uri.parse(ApiUrls.deleteAccount),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await logout();
        return const Right(null);
      } else {
        return Left(ServerErrorFailure(response.statusCode));
      }
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } on NetworkException {
      return Left(const NetworkErrorFailure());
    } catch (e) {
      return Left(UnknownErrorFailure());
    }
  }

  Future<void> _saveUserToCache(
    UserModel user,
    String email,
    String password,
  ) async {
    await LocalStorage.setString(StorageKeys.token, user.token ?? '');
    await LocalStorage.setJson(StorageKeys.user, user.toJson());
    await LocalStorage.setString(StorageKeys.userEmail, email);
    await LocalStorage.setString(StorageKeys.userPassword, password);
  }
}
