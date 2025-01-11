import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kltn_mobile/blocs/profile_status_cubit_bloc/profile_status_cubit.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/constant/theme.dart';

class ActionTabStepper extends StatelessWidget {
  final String header; // parameter header
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
    final backgroundColor = context.select(
      (ThemeSettingCubit cubit) =>
          cubit.state == AppTheme.blackTheme ? AppColor.backgrTabDark : AppColor.backgrTabLight,
    );
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;

    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<ProfileStatusCubit, ProfileStatusState>(
      builder: (context, state) {
        int currentStep = (state is ProfileStatusLoaded && state.status == status) ? state.currentStep : 0;
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
                  padding: const EdgeInsets.only(
                    top: 25.0,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    header,
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      color: textColorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.light(
                            primary: AppColor.redButton,
                          ),
                        ),
                        child: Stepper(
                          currentStep: currentStep,
                          controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
                            return Container();
                          },
                          steps: List.generate(
                            stepTexts.length,
                            (index) => Step(
                              title: Text(
                                stepTexts[index],
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: textColorRed,
                                ),
                              ),
                              content: Container(),
                              isActive: currentStep >= index,
                              state: currentStep == index
                                  ? StepState.indexed
                                  : currentStep > index
                                      ? StepState.complete
                                      : StepState.indexed,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
