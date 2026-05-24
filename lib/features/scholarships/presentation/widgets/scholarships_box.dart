import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/Style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/models/schools.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/pages/scholarships_detail.dart';
import 'package:provider/provider.dart';

class ScholarshipsBox extends StatefulWidget {
  final List<SchoolScholarship> scholarships;

  const ScholarshipsBox({super.key, required this.scholarships});

  @override
  ScholarshipsBoxState createState() => ScholarshipsBoxState();
}

class ScholarshipsBoxState extends State<ScholarshipsBox> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
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
                ImageAssets.gifGraduation,
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              TextMonserats(
                scholarNullKey.tr(),
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
