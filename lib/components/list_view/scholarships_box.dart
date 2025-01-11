import 'package:flutter/material.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/models/schools.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/screens/scholarships/scholarships_detail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScholarshipsBox extends BasePage {
  final List<SchoolScholarship> scholarships;

  const ScholarshipsBox({super.key, required this.scholarships});

  @override
  ScholarshipsBoxState createState() => ScholarshipsBoxState();
}

class ScholarshipsBoxState extends BasePageState<ScholarshipsBox> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final schonull =
        localizations != null ? localizations.schlar_null : "Default Text";
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;
    final boxColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    final scholarships = widget.scholarships;
    final screenHeight = MediaQuery.of(context).size.height;
    if (scholarships.isEmpty) {
      return Container(
        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Graduation.gif',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              TextMonserats(
                schonull,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: textColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: scholarships.length,
      itemBuilder: (context, index) {
        final scholarship = scholarships[index];
        return Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Container(
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: boxColor.withValues(alpha: 0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: TextMonserats(
                scholarship.name,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScholarshipsDetail(
                      name: scholarship.name,
                      description: scholarship.description,
                      id: scholarship.id,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
