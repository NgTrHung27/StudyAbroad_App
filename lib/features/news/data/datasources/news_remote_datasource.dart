import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_helper.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/news/data/models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews();
  Future<NewsModel> getNewsById(String id);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiHelper apiHelper;

  NewsRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await apiHelper.get(ApiUrls.news);
      final List<dynamic> data = _extractData(response);
      return data.map((json) => NewsModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<NewsModel> getNewsById(String id) async {
    try {
      final response = await apiHelper.get(ApiUrls.newsById(id));
      final data = _extractData(response);
      return NewsModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  dynamic _extractData(dynamic response) {
    if (response.data is Map) {
      final data = response.data['data'];
      if (data is List) return data;
      return data;
    }
    return response.data;
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
