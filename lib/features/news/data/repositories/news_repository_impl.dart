import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/features/news/data/models/news_model.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final http.Client _client;

  NewsRepositoryImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<Either<NewsFailure, List<NewsEntity>>> getGeneralNews() async {
    try {
      final response = await _client.get(Uri.parse(ApiUrls.news));

      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<NewsModel> allNews =
            data.map((json) => NewsModel.fromJson(json)).toList();

        // Filter out news that have a specific school attached (general news)
        List<NewsModel> generalNews =
            allNews.where((news) => news.school?.name == null).toList();

        return Right(generalNews);
      } else {
        return const Left(NewsServerFailure('Failed to load news'));
      }
    } catch (e) {
      return const Left(NewsNetworkFailure());
    }
  }

  @override
  Future<Either<NewsFailure, List<NewsEntity>>> getSchoolNews(
      String schoolName) async {
    try {
      final response = await _client.get(Uri.parse(ApiUrls.news));

      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<NewsModel> allNews =
            data.map((json) => NewsModel.fromJson(json)).toList();

        // Filter news for the specific school
        List<NewsModel> schoolNews =
            allNews.where((news) => news.school?.name == schoolName).toList();

        return Right(schoolNews);
      } else {
        return const Left(NewsServerFailure('Failed to load school news'));
      }
    } catch (e) {
      return const Left(NewsNetworkFailure());
    }
  }
}
