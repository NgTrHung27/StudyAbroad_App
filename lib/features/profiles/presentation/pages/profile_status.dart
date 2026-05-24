import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/bloc/legacy/profile_status_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/bloc/legacy/profile_status_event.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/bloc/legacy/profile_status_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/action/actiontab_result.dart';
import 'package:study_abroad_cemc_mobile/components/action/actiontab_stepper.dart';
import 'package:study_abroad_cemc_mobile/components/action/id_tab.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:shimmer/shimmer.dart';

class ProfileStatus extends StatefulWidget {
  const ProfileStatus({super.key});
  @override
  State<ProfileStatus> createState() => _ProfileStatusState();
}

class _ProfileStatusState extends State<ProfileStatus> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserAuthProvider>().fetchFreshProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAuthProvider = context.watch<UserAuthProvider>();
    final userAuth = userAuthProvider.userAuthLogin;
    final isFetching = userAuthProvider.isFetchingProfile;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    //Theme
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;
    return BlocProvider(
      create: (context) => ProfileStatusBloc()
        ..add(UpdateProfileStatusEvent(userAuth?.student?.status ?? 'N/A')),
      child: BlocBuilder<ProfileStatusBloc, ProfileStatusState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.08),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BackButtonCircle(onPressed: () {
                              Navigator.pop(context);
                            }),
                            TextMonserats(
                              profileStatusPS1Key.tr(),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColorRed,
                            ),
                            Container(
                              width: screenwidth * 0.15,
                            )
                          ], // parameters userName+idUser and avatarUser
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      //UserID and UserName
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isFetching)
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: IdTab(
                                userName: 'Loading...',
                                idUser: 'Loading...',
                                avatarImgPath: ImageAssets.logoRed,
                              ),
                            )
                          else
                            IdTab(
                              userName: userAuth?.name ?? 'N/A',
                              idUser: userAuth?.email ?? 'N/A',
                              avatarImgUrl: userAuth?.student?.school.logo != null
                                  ? userAuth!.student?.school.logo
                                  : null,
                              avatarImgPath: ImageAssets.logoRed,
                            ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      //Stepper
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ActionTabStepper(
                              header: profileStatusKey.tr(),
                              stepTexts: [
                                pfsStep1Key.tr(),
                                pfsStep2Key.tr(),
                                pfsStep3Key.tr(),
                              ],
                              status: userAuth?.student?.status ?? 'N/A'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      //Result Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ActiontabResult(
                              result: userAuth?.student?.status ?? 'N/A'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
