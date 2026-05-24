import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_helper.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/schools/data/models/school_model.dart';

abstract class SchoolsRemoteDataSource {
  Future<List<SchoolModel>> getSchools();
  Future<List<String>> getUniqueCountries();
  Future<SchoolModel> getSchoolById(String id);
}

class SchoolsRemoteDataSourceImpl implements SchoolsRemoteDataSource {
  final ApiHelper apiHelper;

  SchoolsRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<List<SchoolModel>> getSchools() async {
    try {
      final response = await apiHelper.get(ApiUrls.schoolsFull);
      final data = _extractData(response);
      final List<dynamic> schoolsJson = data['data'] ?? data;
      return schoolsJson.map((json) => SchoolModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<String>> getUniqueCountries() async {
    try {
      final response = await apiHelper.get(ApiUrls.schools);
      final data = _extractData(response);
      final List<dynamic> schoolsJson = data['data'] ?? data;
      final schools = schoolsJson.map((json) => SchoolModel.fromJson(json)).toList();
      return schools.map((s) => s.country).toSet().toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<SchoolModel> getSchoolById(String id) async {
    try {
      final response = await apiHelper.get(ApiUrls.schoolById(id));
      final data = _extractData(response);
      return SchoolModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Map<String, dynamic> _extractData(Response response) {
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    return {'data': responseData};
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
