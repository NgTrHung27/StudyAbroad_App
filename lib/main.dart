import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/login_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/forgot_pass_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/change_pass_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_event.dart';
import 'package:study_abroad_cemc_mobile/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/bloc/gemini_chat/gemini_chat_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/bloc/legacy/profile_status_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/bloc/apply_scholar_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_event.dart';
import 'package:study_abroad_cemc_mobile/components/constant/theme.dart';
import 'package:study_abroad_cemc_mobile/components/notifications/noti_services.dart';
import 'package:study_abroad_cemc_mobile/firebase_options.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:study_abroad_cemc_mobile/routes/app_route.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_notify.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/client_id.dart';
import 'package:provider/provider.dart';
import 'package:study_abroad_cemc_mobile/core/cache/local_storage.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize LocalStorage
  await LocalStorage.init();
  
  // Initialize dependencies (Dio, repositories, etc.)
  await initDependencies();

  await EasyLocalization.ensureInitialized();

  // Firebase initialization - bọc try-catch vì trên Android, google-services.json
  // có thể đã tự động init Firebase ở tầng native trước khi Dart code chạy.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase already initialized: $e');
  }

  // Chỉ thực thi phần thông báo nếu đang chạy trên Android
  if (Platform.isAndroid) {
    try {
      await initializeNotifications();
      await setupNotificationChannel();
      await listenToForegroundMessages();
      setupFirebaseMessagingBackgroundHandler();
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  // Check login status synchronously from cache
  final userJson = LocalStorage.getJson(StorageKeys.user);
  final token = LocalStorage.getString(StorageKeys.token);
  final isLoggedIn = userJson != null && token != null && token.isNotEmpty;
  
  UserAuthLogin? userAuth;
  if (userJson != null) {
    try {
      userAuth = UserAuthLogin.fromJson(userJson);
    } catch (e) {
      // ignore
    }
  }

  // Also notify the LoginBloc
  final loginBloc = getIt<LoginBloc>();
  loginBloc.add(CheckAuthStatus());

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
        Locale('ko'),
      ],
      path: 'assets/l10n',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => ThemeSettingBloc()..add(LoadThemeEvent())),
          BlocProvider(create: (_) => getIt<AuthBloc>()),
          BlocProvider(create: (_) => loginBloc),
          BlocProvider(create: (_) => ProfileStatusBloc()),
          BlocProvider(create: (_) => getIt<ForgotPassBloc>()),
          BlocProvider(create: (_) => getIt<ChangePassBloc>()),
          BlocProvider(
              create: (context) =>
                  getIt<CarouselBloc>()..add(FetchCarousel())),
          BlocProvider(create: (_) => getIt<NewsBloc>()),
          BlocProvider(create: (_) => getIt<ApplyScholarBloc>()),
          BlocProvider(create: (_) => getIt<SchoolsBloc>()),
          BlocProvider(create: (_) => getIt<ContactUsBloc>()),
          BlocProvider(create: (_) => getIt<GeminiChatBloc>()),
          ChangeNotifierProvider(create: (_) => UserAuthProvider()..setUserAuthLogin()),
          ChangeNotifierProvider(
              create: (_) => AuthNotifier()..setLoggedIn(isLoggedIn)),
          ChangeNotifierProvider(create: (context) => ClientIdProvider()),
        ],
        child: MyApp(userAuth: userAuth),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final UserAuthLogin? userAuth;
  @override
  State<MyApp> createState() => _MyAppState();
  const MyApp({super.key, this.userAuth});
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
return BlocBuilder<ThemeSettingBloc, ThemeSettingState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeState.brightness == Brightness.dark
              ? AppTheme.blackTheme
              : AppTheme.lightTheme,
          themeMode: themeState.themeMode,
          navigatorKey: navigatorKey,
          initialRoute: "/",
          onGenerateRoute: AppRoute.onGenerateRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
