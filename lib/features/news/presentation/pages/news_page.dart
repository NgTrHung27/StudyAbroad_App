import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/news_searchtextfield.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/functions/circle_avatarimg.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/widgets/news_listview_vertical.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/widgets/news_listview_horizontal.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_event.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<void> _onRefresh(BuildContext context, String? schoolName) async {
    context.read<NewsBloc>().add(const LoadGeneralNewsEvent());
    if (schoolName != null && schoolName.isNotEmpty) {
      context.read<NewsBloc>().add(LoadSchoolNewsEvent(schoolName));
    }
    // Wait briefly so the indicator shows before BLoC rebuilds
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = context.watch<UserAuthProvider>().userAuthLogin;
    final isLoggedIn = userAuth != null;
    final schoolName = userAuth?.student?.school.name ?? '';

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;

    return Scaffold(
      backgroundColor: context.select(
          (ThemeSettingBloc bloc) => bloc.state.scaffoldBackgroundColor),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButtonCircle(
                    onPressed: () => Navigator.pop(context),
                  ),
                  CirleAvatarImage(
                      avatarImgUrl: userAuth?.student?.school.logo != null
                          ? userAuth!.student?.school.logo
                          : null,
                      avatarImgPath: ImageAssets.logoRed,
                      width: 60,
                      height: 60),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context, schoolName),
                color: AppColor.redButton,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      const NewsSearchTextField(),
                      SizedBox(height: screenHeight * 0.02),
                      TextMonserats(
                        newsMainKey.tr(),
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const NewsListView(nullSchool: null),
                      SizedBox(height: screenHeight * 0.02),
                      TextMonserats(
                        '${newsPostKey.tr()} \n$schoolName ',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        maxLine: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (!isLoggedIn)
                        TextMonserats(
                          notiContentKey.tr(),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          textAlign: TextAlign.center,
                          maxLine: 2,
                        ),
                      SizedBox(height: screenHeight * 0.02),
                      if (isLoggedIn)
                        VerticalNewsListView(schoolName: schoolName),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
