import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/repositories/news_repository.dart';

class GetNewsUseCase {
  final NewsRepository repository;

  GetNewsUseCase(this.repository);

  Future<Either<NewsFailure, List<NewsEntity>>> call() async {
    return repository.getNews();
  }
}
