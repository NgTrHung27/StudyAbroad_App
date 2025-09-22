import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/news_searchtextfield.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/style/backbutton.dart';
import 'package:kltn_mobile/components/functions/circle_avatarimg.dart';
import 'package:kltn_mobile/components/list_view/news_listview_vertical.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import '../../components/style/montserrat.dart';
import '../../components/list_view/news_listview_horizontal.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';

class NewsPage extends BasePage {
  const NewsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends BasePageState<NewsPage> {
  @override
  Widget build(BuildContext context) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    final isLoggedIn = userAuth != null;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    //theme
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;
    //Language
    final localizations = AppLocalizations.of(context);
    final news1 = localizations != null ? localizations.new_main : 'Default Text';
    final news2 = localizations != null ? localizations.new_post : 'Default Text';
    final news3 = localizations != null ? localizations.noti_1 : 'Default Text';
    return Scaffold(
      backgroundColor: context.select((ThemeSettingCubit cubit) => cubit.state.scaffoldBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonCircle(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CirleAvatarImage(
                    avatarImgUrl: userAuth?.student.school.logo != null ? userAuth!.student.school.logo : null,
                    avatarImgPath: 'assets/logo/logo_red.png',
                    width: 60,
                    height: 60),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            const NewsSearchTextField(),
            SizedBox(height: screenHeight * 0.02),
            TextMonserats(
              news1,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            SizedBox(height: screenHeight * 0.02),
            const NewsListView(nullSchool: null),
            SizedBox(height: screenHeight * 0.02),
            TextMonserats(
              '$news2 \n${userAuth?.student.school.name ?? ''} ',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textColor,
              maxLine: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenHeight * 0.02),
            if (!isLoggedIn)
              TextMonserats(
                news3,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
                textAlign: TextAlign.center,
                maxLine: 2,
              ),
            SizedBox(height: screenHeight * 0.02),
            if (isLoggedIn)
              VerticalNewsListView(
                schoolName: userAuth.student.school.name,
              ),
          ],
        ),
      ),
    );
  }
}
