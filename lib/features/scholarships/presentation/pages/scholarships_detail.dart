import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/Style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/Style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/Style/simplebutton.dart';
import 'package:study_abroad_cemc_mobile/components/functions/circle_avatarimg.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/pages/applyschorlarship.dart';

import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

class ScholarshipsDetail extends StatefulWidget {
  final String name;
  final String description;
  final String id;

  const ScholarshipsDetail(
      {super.key,
      required this.name,
      required this.description,
      required this.id});

  @override
  ScholarshipsDetailState createState() => ScholarshipsDetailState();
}

class ScholarshipsDetailState extends State<ScholarshipsDetail> {
  @override
  Widget build(BuildContext context) {
    final userAuth = context.watch<UserAuthProvider>().userAuthLogin;

    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: boxColor.withValues(alpha: 0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextMonserats(
                            widget.name,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          const SizedBox(height: 10),
                          TextMonserats(
                            widget.description,
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Add some space before the button
                  SimpleButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyPage(
                            name: widget.name,
                            id: widget.id,
                          ),
                        ),
                      );
                    },
                    child: TextMonserats(applyNowKey.tr(), color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              child: const BackButtonCircle(),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              right: 0,
              child: CirleAvatarImage(
                  avatarImgUrl: userAuth?.student?.school.logo != null
                      ? userAuth!.student?.school.logo
                      : null,
                  avatarImgPath: ImageAssets.logoRed,
                  width: 60,
                  height: 60),
            ),
          ],
        ),
      ),
    );
  }
}
