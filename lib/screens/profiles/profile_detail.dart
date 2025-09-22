import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/style/backbutton.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/components/functions/circle_avatarimg.dart';
import 'package:kltn_mobile/components/functions/profile_userdetailbox.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';

class ProfileDetail extends BasePage {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends BasePageState<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;

    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final titleColor = isDarkMode ? Colors.white : AppColor.redButton;
    //Language
    final localizations = AppLocalizations.of(context);
    final profile = localizations != null ? localizations.profile_account_profilesInfo : 'Default Text';
    final fullName = localizations != null ? localizations.register_7_fullname : 'Default Text';
    final dobUser = localizations != null ? localizations.register_10_dob : 'Default Text';
    final phoneUser = localizations != null ? localizations.register_12_phone : 'Default Text';
    final schoolUser = localizations != null ? localizations.profile_account_profilesInfo_School : 'Default Text';
    final majorUser = localizations != null ? localizations.profile_account_profilesInfo_Major : 'Default Text';
    DateTime dob = userAuth?.dob ?? DateTime.now();
    String userFormattedDate = DateFormat('dd/MM/yyyy').format(dob);
    return BlocBuilder<ThemeSettingCubit, ThemeData>(
      builder: (context, state) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
          backgroundColor: context.select((ThemeSettingCubit cubit) => cubit.state.scaffoldBackgroundColor),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.08,
                    bottom: screenHeight * 0.08,
                    left: screenHeight * 0.04,
                    right: screenHeight * 0.04),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextMonserats(
                          profile,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CirleAvatarImage(
                            avatarImgUrl: userAuth?.student.school.logo != null ? userAuth!.student.school.logo : null,
                            avatarImgPath: 'assets/logo/logo_red.png',
                            width: 120,
                            height: 120),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(title: fullName, value: userAuth?.name ?? 'User', isEditable: true),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(title: 'Email', value: userAuth?.email ?? 'Null'),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(title: dobUser, value: userFormattedDate),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(title: phoneUser, value: userAuth?.phoneNumber ?? 'Null'),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(title: schoolUser, value: userAuth?.student.school.name ?? 'Null'),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(title: majorUser, value: userAuth?.student.program?.program.name ?? 'Null'),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenWidth * 0.13,
                left: 10.0,
                child: BackButtonCircle(onPressed: () {
                  Navigator.pop(context);
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
