import 'dart:convert';
import 'dart:io';

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_event.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/bloc/legacy/carousel_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_event.dart';
import 'package:study_abroad_cemc_mobile/components/style/news_searchtextfield.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/widgets/news_listview_horizontal_2.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/functions_main_page/gridview_box.dart';
import 'package:study_abroad_cemc_mobile/components/functions_main_page/hello_avt.dart';
import 'package:study_abroad_cemc_mobile/components/functions_main_page/carousel_loading.dart';
import 'package:study_abroad_cemc_mobile/components/functions_main_page/carousel_slider_data_found.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/models/news.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/client_id.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/schools_list.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

import '../../../news/presentation/bloc/news_bloc.dart';
import '../../../news/presentation/bloc/news_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, NewsList? newsData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CarouselBloc>().add(FetchCarousel());
    context.read<ThemeSettingBloc>().add(LoadThemeEvent());
    context.read<NewsBloc>().add(LoadNewsEvent());
    ShowcaseView.register(
      onComplete: (index, key) {
        debugPrint('onComplete: $index, $key');
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowcaseView.get().startShowCase([_one, _two, _three]);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _initializeNotifications(context);
      }
    });
  }

  Future<void> _initializeNotifications(BuildContext context) async {
    try {
      final userAuth = context.read<UserAuthProvider>().userAuthLogin;

      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.requestPermission();

      // Ensure the APNS token is available only on iOS
      if (Platform.isIOS) {
        String? apnsToken = await firebaseMessaging.getAPNSToken();
        int retries = 0;
        while (apnsToken == null && retries < 10) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await firebaseMessaging.getAPNSToken();
          retries++;
        }
        if (apnsToken == null) return; // Không lấy được APNS token, bỏ qua
      }

      // Fetch the FCM token for this device
      final fCMToken = await firebaseMessaging.getToken();

      // Print the token
      if (fCMToken == null) return;
      final idUser = userAuth?.id;
      final url = Uri.parse(ApiUrls.notificationToken);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': fCMToken, 'userId': idUser}),
      );
      if (mounted) {
        context.read<ClientIdProvider>().setClientId(fCMToken);
      } else {
        print('Failed to post token: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = context.watch<UserAuthProvider>().userAuthLogin;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;
    return Scaffold(
        backgroundColor: context.select(
            (ThemeSettingBloc bloc) => bloc.state.scaffoldBackgroundColor),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
          child: RefreshIndicator(
            color: textColorRed,
            onRefresh: () async {
              // Refresh data on pull-to-refresh
              if (mounted) {
                context.read<CarouselBloc>().add(FetchCarousel());
                context.read<NewsBloc>().add(LoadNewsEvent());
              }
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              controller: _scrollController,
              children: [
                WelcomeAVT(username: userAuth?.name ?? 'User'),
                SizedBox(height: screenHeight * 0.01),
                const NewsSearchTextField(),
                SizedBox(height: screenHeight * 0.02),
                BlocBuilder<CarouselBloc, CarouselState>(
                  builder: (context, state) {
                    if (state is CarouselLoading) {
                      return const CarouselLoadingCustom();
                    } else if (state is CarouselLoaded) {
                      return CarouselSliderDataFound(state.carousels);
                    } else if (state is CarouselError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              state.isNetworkError
                                  ? Icons.wifi_off
                                  : Icons.error_outline,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextMonserats(
                      homeActionKey.tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColorRed,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    const BoxGridView(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    TextMonserats(
                      homeExploreKey.tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColorRed,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SchoolsListPage(country: 'CANADA'),
                                ),
                              );
                            },
                            child: SizedBox(
                                width: 330,
                                child:
                                    Image.asset(ImageAssets.countryCanada)),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SchoolsListPage(
                                      country: 'AUSTRALIA'),
                                ),
                              );
                            },
                            child: SizedBox(
                                width: 330,
                                child: Image.asset(
                                    ImageAssets.countryAustralia)),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SchoolsListPage(country: 'KOREA'),
                                ),
                              );
                            },
                            child: SizedBox(
                                width: 330,
                                child:
                                    Image.asset(ImageAssets.countryKorea)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextMonserats(homeNewListKey.tr(),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textColorRed),
                    SizedBox(height: screenHeight * 0.02),
                    const NewsListViewShort(
                      nullSchool: null,
                    ),
                    SizedBox(height: screenHeight * 0.14),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
