import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';

abstract class NewsRepository {
  Future<Either<NewsFailure, List<NewsEntity>>> getNews();
  Future<Either<NewsFailure, NewsEntity>> getNewsById(String id);
  Future<Either<NewsFailure, List<NewsEntity>>> getGeneralNews();
  Future<Either<NewsFailure, List<NewsEntity>>> getSchoolNews(String schoolName);
}
