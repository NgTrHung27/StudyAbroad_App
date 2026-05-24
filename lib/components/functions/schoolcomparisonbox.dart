import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';

class ComparisonChart extends StatelessWidget {
  final String titleComparison;
  final List<String> schoolNames;

  const ComparisonChart({
    super.key,
    required this.titleComparison,
    required this.schoolNames,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1,
              ),
            ),
            constraints: const BoxConstraints(
              minWidth: double.infinity,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                TextMonserats(
                  titleComparison,
                  color: textColor,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
                Transform(
                  transform:
                      Matrix4.translationValues(0.0, screenHeight * 0.065, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: schoolNames.map((name) {
                            final double percentage =
                                Random().nextDouble() * 100;
                            return Column(
                              children: [
                                Container(
                                  width: screenWidth * 0.25,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  constraints: const BoxConstraints(
                                      minHeight: 80, maxHeight: 200),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        width: screenWidth * 0.15,
                                        height: screenHeight * 0.24,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: screenWidth * 0.15,
                                          height: percentage * 2.0,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColor.orangeWarning,
                                                AppColor.redWarning,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        child: Text(
                                          '${percentage.toStringAsFixed(0)}%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.04,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: screenHeight * 0.055,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: schoolNames.map((name) {
                              return SizedBox(
                                width: screenWidth * 0.3,
                                child: TextMonserats(
                                  name,
                                  color: textColor,
                                  fontSize: screenWidth * 0.033,
                                  fontWeight: FontWeight.w600,
                                  maxLine: 3,
                                  height: 1.2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
