import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/models/user_login.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class TuitionBox extends BasePage {
  const TuitionBox({
    super.key,
    required this.tuition,
  });
  final Tuition tuition;

  @override
  TuitionBoxDetailState createState() => TuitionBoxDetailState();
}

class TuitionBoxDetailState extends BasePageState<TuitionBox> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    Color statusColor;
    final List<String?> tuitionStatuses =
        userAuth?.student.tuitions?.map((tuition) => tuition.status).toList() ??
            [];
    final String? currentStatus =
        tuitionStatuses.isNotEmpty ? tuitionStatuses[0] : 'Unknown';
    switch (currentStatus) {
      case 'PAID':
        statusColor = const Color(0xff65AF37);
        break;
      case 'OVERDUE':
        statusColor = const Color(0xffC81D1D);
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final boxColor = isDarkMode ? const Color(0xff3F3F46) : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;

    return Container(
      margin: EdgeInsets.only(
          left: screenwidth * 0.06,
          right: screenwidth * 0.06,
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
            horizontal: screenwidth * 0.05, vertical: screenHeight * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenwidth * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextMonserats(widget.tuition.description ?? '',
                      color: textColor,
                      fontSize: screenwidth * 0.04,
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: screenHeight * 0.01),
                  TextMonserats(
                    '\$${widget.tuition.amount}',
                    color: Colors.red,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            Transform(
              transform:
                  Matrix4.translationValues(0.0, -screenHeight * 0.02, 0.0),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.008,
                    horizontal: screenwidth * 0.05),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                constraints: BoxConstraints(
                  minWidth: screenwidth * 0.2,
                ),
                child: Center(
                  child: TextMonserats(
                    widget.tuition.status ?? 'Null',
                    color: Colors.white,
                    fontSize: screenwidth * 0.036,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
