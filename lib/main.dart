import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/auth_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/forgot_pass_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/login_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/login_event.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_event.dart';
import 'package:study_abroad_cemc_mobile/blocs/contact_us_bloc/contact_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/bloc/legacy/profile_status_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector_conf.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_event.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/pages/applyschorlarship.dart';
import 'package:study_abroad_cemc_mobile/components/constant/theme.dart';
import 'package:study_abroad_cemc_mobile/components/notifications/noti_services.dart';
import 'package:study_abroad_cemc_mobile/firebase_options.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:study_abroad_cemc_mobile/routes/app_route.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_notify.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/client_id.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  await EasyLocalization.ensureInitialized();

  //FirebaseMess
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Kiểm tra nếu đang chạy trên Android
  bool isRunningOnAndroid = Platform.isAndroid;

  // Chỉ thực thi phần thông báo nếu đang chạy trên Android
  if (isRunningOnAndroid) {
    await Firebase.initializeApp();
    await initializeNotifications();
    await setupNotificationChannel();
    await listenToForegroundMessages();
    setupFirebaseMessagingBackgroundHandler();
  }

  // Kiểm tra session đăng nhập
  final loginBloc = LoginBloc(APIRepository());
  final userAuth = await loginBloc.checkLoginStatus();
  final isLoggedIn = userAuth != null;

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
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (_) => loginBloc),
          BlocProvider(create: (_) => ProfileStatusBloc()),
          BlocProvider(create: (_) => ForgotPassBloc(APIRepository())),
          BlocProvider(
              create: (context) =>
                  CarouselBloc(APIRepository())..add(FetchCarousel())),
          BlocProvider(create: (_) => getIt<NewsBloc>()),
          BlocProvider(create: (_) => ApplyScholarBloc()),
          BlocProvider(create: (_) => getIt<SchoolBloc>()),
          BlocProvider(create: (_) => ContactUsBloc(APIRepository())),
          ChangeNotifierProvider(create: (_) => UserAuthProvider()),
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
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(CheckLoginStatusEvent());
  }

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
