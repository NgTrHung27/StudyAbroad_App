import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/core/cache/local_storage.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/auth/data/models/user_model.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_abroad_cemc_mobile/models/country.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save tokens
      await LocalStorage.setString(StorageKeys.token, authResponse.token);
      if (authResponse.refreshToken != null) {
        await LocalStorage.setString(StorageKeys.refreshToken, authResponse.refreshToken!);
      }

      // Save user to cache
      await _saveUserToCache(authResponse.user, email, password);

      return Right(authResponse.user);
    } on UnauthorizedException {
      return const Left(InvalidCredentialsFailure());
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
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
    try {
      final user = await remoteDataSource.register(
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
      return Right(user);
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await LocalStorage.remove(StorageKeys.token);
      await LocalStorage.remove(StorageKeys.user);
      await LocalStorage.remove(StorageKeys.userEmail);
      await LocalStorage.remove(StorageKeys.userPassword);
      return const Right(null);
    } catch (e) {
      return const Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, String>> refreshToken() async {
    return const Left(UnknownErrorFailure());
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
  Future<Either<AuthFailure, UserEntity>> getCurrentProfile() async {
    try {
      final user = await remoteDataSource.getCurrentProfile();
      
      final email = LocalStorage.getString(StorageKeys.userEmail) ?? '';
      final password = LocalStorage.getString(StorageKeys.userPassword) ?? '';
      await _saveUserToCache(user, email, password);
      
      return Right(user);
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> verifyEmail(String token) async {
    try {
      await remoteDataSource.verifyEmail(token);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      await logout();
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
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

  @override
  Future<Either<AuthFailure, List<Country>>> getCountries() async {
    try {
      final countries = await remoteDataSource.getCountries();
      return Right(countries);
    } on NetworkException {
      return const Left(NetworkErrorFailure());
    } on ServerException catch (e) {
      return Left(ServerErrorFailure(e.statusCode));
    } catch (e) {
      return const Left(UnknownErrorFailure());
    }
  }
}
