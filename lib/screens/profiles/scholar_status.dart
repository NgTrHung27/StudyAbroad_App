import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/action/actiontab_result.dart';
import 'package:kltn_mobile/components/action/id_tab.dart';
import 'package:kltn_mobile/components/action/stepper.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/style/backbutton.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class ScholarStuStatus extends BasePage {
  final String status;
  const ScholarStuStatus(this.status, {super.key});
  @override
  State<ScholarStuStatus> createState() => _ScholarStuStatusState();
}

class _ScholarStuStatusState extends BasePageState<ScholarStuStatus> {
  @override
  Widget build(BuildContext context) {
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;

    final screenHeight = MediaQuery.of(context).size.height;

    // Theme
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Row(
                    children: [
                      BackButtonCircle(onPressed: () {
                        Navigator.pop(context);
                      }),
                      const Spacer(),
                      TextMonserats(
                        'Scholarship \n Status',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: textColorRed,
                        softWrap: true,
                        maxLine: 2,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // UserID and UserName
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IdTab(
                            userName: userAuth?.name ?? 'N/A',
                            idUser: userAuth?.email ?? 'N/A',
                            avatarImgUrl: userAuth?.student.school.logo != null
                                ? userAuth!.student.school.logo
                                : null,
                            avatarImgPath: 'assets/logo/logo_red.png',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        // Khoảng cách từ các cạnh
                        decoration: BoxDecoration(
                          color: Colors.white, // Màu nền trắng
                          borderRadius: BorderRadius.circular(16.0), // Bo góc
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0,
                                  4), // Thay đổi để điều chỉnh hướng của bóng đổ
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height:
                              350.0, // Đặt chiều cao cố định cho toàn bộ Stepper
                          child: StepperDemo(
                            header: 'Scholarship Status',
                            titles: const [
                              'Application has been submitted',
                              'Awaiting review',
                              'Done'
                            ],
                            contents: const [
                              Text(''),
                              Text('Waiting time is about 3-5 days'),
                              Text(''),
                            ],
                            status: widget.status,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  //Result Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActiontabResult(
                        result: widget.status, // Trạng thái kết quả
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
