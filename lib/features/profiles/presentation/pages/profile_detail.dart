import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_state.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/functions/circle_avatarimg.dart';
import 'package:study_abroad_cemc_mobile/components/functions/profile_userdetailbox.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/base_lang.dart';

class ProfileDetail extends BasePage {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends BasePageState<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;

    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final titleColor = isDarkMode ? Colors.white : AppColor.redButton;
    DateTime dob = userAuth?.dob ?? DateTime.now();
    String userFormattedDate = DateFormat('dd/MM/yyyy').format(dob);
    return BlocBuilder<ThemeSettingBloc, ThemeSettingState>(
      builder: (context, state) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
          backgroundColor: context.select(
              (ThemeSettingBloc bloc) => bloc.state.scaffoldBackgroundColor),
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
                          profileAccountInfoKey.tr(),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CirleAvatarImage(
                            avatarImgUrl: userAuth?.student?.school.logo != null
                                ? userAuth!.student?.school.logo
                                : null,
                            avatarImgPath: 'assets/logo/logo_red.png',
                            width: 120,
                            height: 120),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(
                            title: registerFullnameKey.tr(),
                            value: userAuth?.name ?? 'User',
                            isEditable: true),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(
                            title: 'Email', value: userAuth?.email ?? 'Null'),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(
                            title: registerDobKey.tr(),
                            value: userFormattedDate),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(
                            title: registerPhoneKey.tr(),
                            value: userAuth?.phoneNumber ?? 'Null'),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(
                            title: profileInfoSchoolKey.tr(),
                            value: userAuth?.student?.school.name ?? 'Null'),
                        SizedBox(height: screenHeight * 0.02),
                        LegendBox(
                            title: profileInfoMajorKey.tr(),
                            value: userAuth?.student?.program?.program.name ??
                                'Null'),
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
