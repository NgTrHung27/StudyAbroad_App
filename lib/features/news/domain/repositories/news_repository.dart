import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';

abstract class NewsRepository {
  /// Fetch general news (where school is null)
  Future<Either<NewsFailure, List<NewsEntity>>> getGeneralNews();

  /// Fetch news for a specific school
  Future<Either<NewsFailure, List<NewsEntity>>> getSchoolNews(
      String schoolName);
}
