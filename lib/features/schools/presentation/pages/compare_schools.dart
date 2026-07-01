import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/functions/schoolcomparisonbox.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';

class CompareSchoolsPage extends StatelessWidget {
  final List<String> schoolNames;
  const CompareSchoolsPage({super.key, required this.schoolNames});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.all(screenHeight * 0.025),
              child: Center(
                child: TextMonserats(schDescKey.tr(),
                    fontSize: screenHeight * 0.03, color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                  titleComparison: cpSchool2Key.tr(), schoolNames: schoolNames),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                  titleComparison: cpSchool3Key.tr(), schoolNames: schoolNames),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                  titleComparison: cpSchool4Key.tr(), schoolNames: schoolNames),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                  titleComparison: cpSchool5Key.tr(), schoolNames: schoolNames),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                  titleComparison: cpSchool6Key.tr(), schoolNames: schoolNames),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                  titleComparison: cpSchool7Key.tr(), schoolNames: schoolNames),
            ),
          ],
        ),
      ),
      const Positioned(
        top: 10,
        left: 10,
        child: BackButtonCircle(),
      ),
    ],
  ),
),
);
}
}
