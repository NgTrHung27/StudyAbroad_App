import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/screens/profiles/scholar_status.dart';

class ScholarStatusWidget extends StatelessWidget {
  final String scholarStatus;
  final String name;

  const ScholarStatusWidget({
    super.key,
    required this.scholarStatus,
    required this.name,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final boxColor = isDarkMode ? const Color(0xff3F3F46) : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScholarStuStatus(scholarStatus),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
            bottom: screenHeight * 0.02),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextMonserats(
                      name,
                      color: textColor,
                      fontSize: screenWidth * 0.04,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLine: 2,
                    ),
                  ],
                ),
              ),
              Transform(
                transform:
                    Matrix4.translationValues(0.0, -screenHeight * 0.0, 0.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.008,
                      horizontal: screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: _getStatusColor(scholarStatus),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  constraints: BoxConstraints(
                    minWidth: screenWidth * 0.33,
                  ),
                  child: Center(
                    child: TextMonserats(
                      scholarStatus,
                      color: Colors.white,
                      fontSize: screenWidth * 0.036,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
