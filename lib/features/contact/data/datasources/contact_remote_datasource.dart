import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_helper.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';

abstract class ContactRemoteDataSource {
  Future<void> submitContact({
    required String name,
    required String email,
    required String title,
    required String phone,
    required String message,
    String? schoolId,
  });
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final ApiHelper apiHelper;

  ContactRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<void> submitContact({
    required String name,
    required String email,
    required String title,
    required String phone,
    required String message,
    String? schoolId,
  }) async {
    try {
      // API /feedbacks trên admin backend (Vercel) dùng Clerk auth riêng,
      // không chấp nhận Bearer token của app. Gửi request không có header
      // Authorization để tránh lỗi 401 Unauthorized.
      await apiHelper.post(
        ApiUrls.feedbacks,
        data: {
          'name': name,
          'email': email,
          'title': title,
          'phone': phone,
          'message': message,
          if (schoolId != null) 'schoolId': schoolId,
        },
        options: Options(headers: <String, dynamic>{'Authorization': null}),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.error is NetworkException) {
      return e.error as NetworkException;
    }
    if (e.error is ServerException) {
      return e.error as ServerException;
    }
    if (e.response?.statusCode == 400) {
      return ServerException(
        message: 'Validation failed',
        statusCode: 400,
      );
    }
    return ServerException(
      message: e.message,
      statusCode: e.response?.statusCode,
    );
  }
}
