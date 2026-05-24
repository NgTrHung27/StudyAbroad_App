import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_helper.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';

abstract class ScholarshipRemoteDataSource {
  Future<Map<String, dynamic>> applyScholarship({
    required String url,
    required String studentId,
    required String scholarshipId,
    required String additional,
  });
}

class ScholarshipRemoteDataSourceImpl implements ScholarshipRemoteDataSource {
  final ApiHelper apiHelper;

  ScholarshipRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<Map<String, dynamic>> applyScholarship({
    required String url,
    required String studentId,
    required String scholarshipId,
    required String additional,
  }) async {
    try {
      final response = await apiHelper.post(
        url,
        data: {
          'studentId': studentId,
          'additional': additional,
        },
      );

      return response.data;
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
    return ServerException(
      message: e.message,
      statusCode: e.response?.statusCode,
    );
  }
}
