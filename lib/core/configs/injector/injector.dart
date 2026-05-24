import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_helper.dart';

// Features - Schools
import 'package:study_abroad_cemc_mobile/features/schools/data/datasources/schools_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/schools/data/repositories/schools_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/schools_repository.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_schools_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_school_by_id_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_unique_countries_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_bloc.dart';

// Features - News
import 'package:study_abroad_cemc_mobile/features/news/data/datasources/news_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/news/data/repositories/news_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/repositories/news_repository.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/usecases/get_news_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';

// Features - Auth
import 'package:study_abroad_cemc_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/login_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/forgot_pass_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/change_pass_bloc.dart';

// Features - Home
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_bloc.dart';

// Features - Contact
import 'package:study_abroad_cemc_mobile/features/contact/data/datasources/contact_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/repositories/contact_repository.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/usecases/submit_contact_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/contact/presentation/bloc/contact_bloc.dart';

// Features - Scholarships
import 'package:study_abroad_cemc_mobile/features/scholarships/data/datasources/scholarship_remote_datasource.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/data/repositories/scholarship_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/repositories/scholarship_repository.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/usecases/apply_scholarship_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/bloc/apply_scholar_bloc.dart';

// Features - Chatting
import 'package:study_abroad_cemc_mobile/features/chatting/data/repositories/chatting_repository_impl.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/bloc/gemini_chat/gemini_chat_bloc.dart';

// Global Blocs
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_event.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // ==================== CORE ====================
  
  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());
  
  // API Helper
  getIt.registerLazySingleton<ApiHelper>(() => ApiHelper());
  
  // Local Storage (singleton, already initialized)
  // Note: LocalStorage.init() must be called in main.dart before this

  // ==================== SCHOOLS FEATURE ====================
  
  // Data Sources
  getIt.registerLazySingleton<SchoolsRemoteDataSource>(
    () => SchoolsRemoteDataSourceImpl(apiHelper: getIt<ApiHelper>()),
  );
  
  // Repositories
  getIt.registerLazySingleton<SchoolsRepository>(
    () => SchoolsRepositoryImpl(remoteDataSource: getIt<SchoolsRemoteDataSource>()),
  );
  
  // Use Cases
  getIt.registerLazySingleton(() => GetSchoolsUseCase(getIt<SchoolsRepository>()));
  getIt.registerLazySingleton(() => GetSchoolByIdUseCase(getIt<SchoolsRepository>()));
  getIt.registerLazySingleton(() => GetUniqueCountriesUseCase(getIt<SchoolsRepository>()));
  
  // BLoC - Factory (new instance each time)
  getIt.registerFactory(() => SchoolsBloc(
    getSchoolsUseCase: getIt<GetSchoolsUseCase>(),
    getSchoolByIdUseCase: getIt<GetSchoolByIdUseCase>(),
  ));

  // ==================== HOME FEATURE ====================
  
  // BLoC - Factory
  getIt.registerFactory(() => CarouselBloc(
    getSchoolsUseCase: getIt<GetSchoolsUseCase>(),
  ));

  // ==================== NEWS FEATURE ====================
  
  // Data Sources
  getIt.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(apiHelper: getIt<ApiHelper>()),
  );
  
  // Repositories
  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: getIt<NewsRemoteDataSource>()),
  );
  
  // Use Cases
  getIt.registerLazySingleton(() => GetNewsUseCase(getIt<NewsRepository>()));
  getIt.registerLazySingleton(() => GetNewsByIdUseCase(getIt<NewsRepository>()));
  
  // BLoC - Factory
  getIt.registerFactory(() => NewsBloc(
    getNewsUseCase: getIt<GetNewsUseCase>(),
    getNewsByIdUseCase: getIt<GetNewsByIdUseCase>(),
  ));

  // ==================== AUTH FEATURE ====================
  
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiHelper: getIt<ApiHelper>()),
  );
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  
  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  
  // BLoC - Factory
  getIt.registerFactory(() => LoginBloc(
    loginUseCase: getIt<LoginUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
  ));
  
  getIt.registerFactory(() => AuthBloc(
    registerUseCase: getIt<RegisterUseCase>(),
    getSchoolsUseCase: getIt<GetSchoolsUseCase>(),
    getUniqueCountriesUseCase: getIt<GetUniqueCountriesUseCase>(),
  ));
  
  getIt.registerFactory(() => ForgotPassBloc(
    authRepository: getIt<AuthRepository>(),
  ));
  
  getIt.registerFactory(() => ChangePassBloc(
    authRepository: getIt<AuthRepository>(),
  ));

  // ==================== CHATTING FEATURE ====================

  getIt.registerLazySingleton<ChattingRepository>(
    () => ChattingRepositoryImpl(),
  );

  getIt.registerFactory(() => GeminiChatBloc(
    getIt<ChattingRepository>(),
  ));

  // ==================== CONTACT FEATURE ====================

  // Data Sources
  getIt.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(apiHelper: getIt<ApiHelper>()),
  );

  // Repositories
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(remoteDataSource: getIt<ContactRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => SubmitContactUseCase(getIt<ContactRepository>()));

  // BLoC - Factory
  getIt.registerFactory(() => ContactUsBloc(
    submitContactUseCase: getIt<SubmitContactUseCase>(),
    getSchoolsUseCase: getIt<GetSchoolsUseCase>(),
  ));

  // ==================== SCHOLARSHIPS FEATURE ====================

  // Data Sources
  getIt.registerLazySingleton<ScholarshipRemoteDataSource>(
    () => ScholarshipRemoteDataSourceImpl(apiHelper: getIt<ApiHelper>()),
  );

  // Repositories
  getIt.registerLazySingleton<ScholarshipRepository>(
    () => ScholarshipRepositoryImpl(remoteDataSource: getIt<ScholarshipRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => ApplyScholarshipUseCase(getIt<ScholarshipRepository>()));

  // BLoC - Factory
  getIt.registerFactory(() => ApplyScholarBloc(
    applyScholarshipUseCase: getIt<ApplyScholarshipUseCase>(),
  ));

  // ==================== GLOBAL BLOCS ====================
  
  // Theme BLoC - Singleton (shared across app)
  getIt.registerLazySingleton(() => ThemeSettingBloc()..add(LoadThemeEvent()));
}
