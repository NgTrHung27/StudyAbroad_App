import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/repositories/news_repository.dart';

class GetNewsByIdUseCase {
  final NewsRepository repository;

  GetNewsByIdUseCase(this.repository);

  Future<Either<NewsFailure, NewsEntity>> call(String newsId) async {
    return repository.getNewsById(newsId);
  }
}
