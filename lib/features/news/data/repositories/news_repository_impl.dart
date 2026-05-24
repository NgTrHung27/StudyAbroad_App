import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/features/news/data/datasources/news_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NewsFailure, List<NewsEntity>>> getNews() async {
    try {
      final news = await remoteDataSource.getNews();
      return Right(news);
    } on NetworkException catch (e) {
      return Left(NewsNetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(NewsServerFailure(e.message));
    } on ParseException catch (e) {
      return Left(NewsParseFailure(e.message));
    } catch (e) {
      return Left(NewsServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<NewsFailure, NewsEntity>> getNewsById(String id) async {
    try {
      final news = await remoteDataSource.getNewsById(id);
      return Right(news);
    } on NetworkException catch (e) {
      return Left(NewsNetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(NewsServerFailure(e.message));
    } on ParseException catch (e) {
      return Left(NewsParseFailure(e.message));
    } catch (e) {
      return Left(NewsServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<NewsFailure, List<NewsEntity>>> getGeneralNews() async {
    try {
      final allNews = await remoteDataSource.getNews();
      final generalNews = allNews.where((news) => news.school?.name == null).toList();
      return Right(generalNews);
    } on NetworkException catch (e) {
      return Left(NewsNetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(NewsServerFailure(e.message));
    } catch (e) {
      return Left(NewsServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<NewsFailure, List<NewsEntity>>> getSchoolNews(String schoolName) async {
    try {
      final allNews = await remoteDataSource.getNews();
      final schoolNews = allNews.where((news) => news.school?.name == schoolName).toList();
      return Right(schoolNews);
    } on NetworkException catch (e) {
      return Left(NewsNetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(NewsServerFailure(e.message));
    } catch (e) {
      return Left(NewsServerFailure(e.toString()));
    }
  }
}
