import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/functions/schoolcomparisonbox.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';

class CompareSchoolsPage extends StatelessWidget {
  final List<String> schoolNames;
  const CompareSchoolsPage({super.key, required this.schoolNames});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;
    final localizations = AppLocalizations.of(context);
    final cpSchool = localizations != null ? localizations.sch_desc : 'Default Text';
    final cpSchool2 = localizations != null ? localizations.cpSchool2 : 'Default Text';
    final cpSchool3 = localizations != null ? localizations.cpSchool3 : 'Default Text';
    final cpSchool4 = localizations != null ? localizations.cpSchool4 : 'Default Text';
    final cpSchool5 = localizations != null ? localizations.cpSchool5 : 'Default Text';
    final cpSchool6 = localizations != null ? localizations.cpSchool6 : 'Default Text';
    final cpSchool7 = localizations != null ? localizations.cpSchool7 : 'Default Text';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Padding(
              padding: EdgeInsets.all(screenHeight * 0.025),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: BackButtonCircle(), // Add BackButtonCircle
                  ),
                  Center(
                    child: TextMonserats(
                      cpSchool,
                      fontSize: screenHeight * 0.03,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                titleComparison: cpSchool2,
                schoolNames: schoolNames,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                titleComparison: cpSchool3,
                schoolNames: schoolNames,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                titleComparison: cpSchool4,
                schoolNames: schoolNames,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                titleComparison: cpSchool5,
                schoolNames: schoolNames,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                titleComparison: cpSchool6,
                schoolNames: schoolNames,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ComparisonChart(
                titleComparison: cpSchool7,
                schoolNames: schoolNames,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
