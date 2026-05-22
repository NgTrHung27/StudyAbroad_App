import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:study_abroad_cemc_mobile/core/api/api_helper.dart';
import 'package:study_abroad_cemc_mobile/core/cache/local_storage.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';
import 'package:study_abroad_cemc_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/schools/data/repositories/school_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/school_repository.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/data/repositories/news_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/repositories/news_repository.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
final getIt = GetIt.instance;

/// Configure all dependencies for the app
Future<void> configureDependencies() async {
  // Initialize LocalStorage first
  await LocalStorage.init();

  // Core
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<ApiHelper>(() => ApiHelper(getIt<http.Client>()));

  // Repositories
  getIt.registerLazySingleton<APIRepository>(() => APIRepository());
  
  // Auth Repository (Clean Architecture)
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // BLoCs (Factory - new instance each time)
  // Clean Architecture Auth BLoC
  getIt.registerFactory<AuthBloc>(() => AuthBloc(repository: getIt<AuthRepository>()));

  // Schools Feature
  getIt.registerLazySingleton<SchoolRepository>(() => SchoolRepositoryImpl(client: getIt<http.Client>()));
  getIt.registerFactory<SchoolBloc>(() => SchoolBloc(repository: getIt<SchoolRepository>()));

  // News Feature
  getIt.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(client: getIt<http.Client>()));
  getIt.registerFactory<NewsBloc>(() => NewsBloc(repository: getIt<NewsRepository>()));
}
