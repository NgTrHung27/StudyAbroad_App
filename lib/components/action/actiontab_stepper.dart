import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/blocs/profile_status_cubit_bloc/profile_status_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/profile_status_cubit_bloc/profile_status_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

class ActionTabStepper extends StatelessWidget {
  final String header;
  final List<String> stepTexts;
  final String status;

  const ActionTabStepper({
    super.key,
    required this.header,
    required this.stepTexts,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        context.select((ThemeSettingBloc bloc) => bloc.state.isDarkMode);
    final backgroundColor =
        isDarkMode ? AppColor.backgrTabDark : AppColor.backgrTabLight;
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;

    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<ProfileStatusBloc, ProfileStatusState>(
      builder: (context, state) {
        int currentStep = 0;
        if (state is ProfileStatusLoaded && state.status == status) {
          currentStep = state.currentStep;
        }
        return SingleChildScrollView(
          child: Container(
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    header,
                    style: GoogleFonts.getFont(
                      'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColorRed,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(stepTexts.length, (index) {
                    final isCompleted = index < currentStep;
                    final isCurrent = index == currentStep;
                    return Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (index > 0)
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: isCompleted
                                        ? AppColor.backgrTabLight
                                        : Colors.grey[300],
                                  ),
                                ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCompleted
                                      ? textColorRed
                                      : (isCurrent
                                          ? textColorRed.withValues(alpha: 0.5)
                                          : Colors.grey[300]),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isCompleted || isCurrent
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (index < stepTexts.length - 1)
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: isCompleted
                                        ? textColorRed
                                        : Colors.grey[300],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stepTexts[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              'Montserrat',
                              fontSize: 10,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
