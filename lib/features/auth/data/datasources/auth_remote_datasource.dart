import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_helper.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/auth/data/models/user_model.dart';
import 'package:study_abroad_cemc_mobile/models/country.dart';

import '../../../../core/cache/local_storage.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login({required String email, required String password});
  Future<List<Country>> getCountries(); Future<UserModel> register({
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
  });
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<UserModel?> getCachedUser();
  Future<UserModel> getCurrentProfile();
  Future<void> forgotPassword(String email);
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });
  Future<void> verifyEmail(String token);
  Future<void> deleteAccount();
}

class AuthResponse {
  final UserModel user;
  final String token;
  final String? refreshToken;

  AuthResponse({
    required this.user,
    required this.token,
    this.refreshToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiHelper apiHelper;

  AuthRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<List<Country>> getCountries() async {
    try {
      final response = await apiHelper.get(ApiUrls.countries);
      final data = response.data;
      final List<dynamic> countriesJson = data['data'] ?? [];
      return countriesJson.map((json) => Country.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiHelper.post(
        ApiUrls.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final token = data['data']['token'];
      final refreshToken = data['data']['refreshToken'];

      // Get user profile
      final userResponse = await apiHelper.get(
        ApiUrls.currentProfile,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final userData = userResponse.data['data'];
      final user = UserModel.fromJson(userData);

      return AuthResponse(
        user: user,
        token: token,
        refreshToken: refreshToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> register({
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
      final body = <String, dynamic>{
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'name': name,
        'phoneNumber': phoneNumber,
        'idCardNumber': idCardNumber,
        'dob': dob.toIso8601String(),
      };

      if (schoolName != null) body['schoolName'] = schoolName;
      if (country != null) body['country'] = country;
      if (programName != null) body['programName'] = programName;
      if (city != null) body['city'] = city;
      if (district != null) body['district'] = district;
      if (ward != null) body['ward'] = ward;
      if (addressLine != null) body['addressLine'] = addressLine;
      if (gender != null) body['gender'] = gender;
      if (degreeType != null) body['degreeType'] = degreeType;
      if (gradeType != null) body['gradeType'] = gradeType;
      if (gradeScore != null) body['gradeScore'] = gradeScore;
      if (certificateType != null) body['certificateType'] = certificateType;
      if (certificateImg != null) body['certificateImg'] = certificateImg;

      final response = await apiHelper.post(
        ApiUrls.register,
        data: body,
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    // Already handled in repository
  }

  @override
  Future<bool> isLoggedIn() async {
    // Already handled in repository
    return true;
  }

  @override
  Future<UserModel?> getCachedUser() async {
    // Already handled in repository
    return null;
  }

  @override
  Future<UserModel> getCurrentProfile() async {
    try {
      final token = LocalStorage.getString(StorageKeys.token);
      final userResponse = await apiHelper.get(
        ApiUrls.currentProfile,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final userData = userResponse.data['data'];
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await apiHelper.post(
        ApiUrls.resetPassword,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await apiHelper.post(
        ApiUrls.resetPassword,
        data: {
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await apiHelper.post(
        ApiUrls.emailVerification,
        data: {'token': token},
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await apiHelper.delete(ApiUrls.deleteAccount);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.error is NetworkException) {
      return e.error as NetworkException;
    }
    if (e.error is UnauthorizedException) {
      return e.error as UnauthorizedException;
    }
    if (e.error is ServerException) {
      return e.error as ServerException;
    }
    if (e.response?.statusCode == 401) {
      return UnauthorizedException(message: 'Invalid credentials');
    }
    if (e.response?.statusCode == 406) {
      return ValidationException(message: 'Validation failed');
    }
    return ServerException(
      message: e.message,
      statusCode: e.response?.statusCode,
    );
  }
}

class ValidationException implements Exception {
  final String? message;
  const ValidationException({this.message});
}
