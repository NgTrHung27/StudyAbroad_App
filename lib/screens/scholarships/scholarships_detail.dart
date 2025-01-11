import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/Style/simplebutton.dart';
import 'package:kltn_mobile/components/functions/circle_avatarimg.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/screens/scholarships/applyschorlarship.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/theme_setting_cubit/theme_setting_cubit.dart';

class ScholarshipsDetail extends BasePage {
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

class ScholarshipsDetailState extends BasePageState<ScholarshipsDetail> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? const Color(0xff3F3F46) : Colors.white;
    final localizations = AppLocalizations.of(context);
    final applyNow =
        localizations != null ? localizations.apply_now : 'Default Text';
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
                    child: TextMonserats(applyNow, color: Colors.white),
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
                  avatarImgUrl: userAuth?.student.school.logo != null
                      ? userAuth!.student.school.logo
                      : null,
                  avatarImgPath: 'assets/logo/logo_red.png',
                  width: 60,
                  height: 60),
            ),
          ],
        ),
      ),
    );
  }
}
