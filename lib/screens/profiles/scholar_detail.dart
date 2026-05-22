import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/Style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/Style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/action/id_tab.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/list_view/scholar_box.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/screens/home/base_lang.dart';

class ScholarDetail extends BasePage {
  const ScholarDetail({super.key});

  @override
  ScholarDetailState createState() => ScholarDetailState();
}

class ScholarDetailState extends BasePageState<ScholarDetail> {
  Future<UserAuthLogin?> getUserAuth(BuildContext context) async {
    return userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<UserAuthLogin?>(
          future: getUserAuth(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userAuth = snapshot.data!;
              final List<StudentSchoolScholarship>? scholarshipList =
                  userAuth.student?.scholarship;
              return Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.08),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: TextMonserats(
                            'Scholarship\nStatus',
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            softWrap: true,
                            maxLine: 2,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            height: 1.3,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: IdTab(
                          userName: userAuth.name ?? 'N/A',
                          idUser: userAuth.email,
                          avatarImgUrl: userAuth.student?.school
                              .logo, // Sử dụng hình ảnh từ API nếu có
                          avatarImgPath: 'assets/logo/logo_white.png',
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: scholarshipList?.length,
                          itemBuilder: (context, index) {
                            return ScholarStatusWidget(
                                scholarStatus: scholarshipList![index].status,
                                name:
                                    scholarshipList[index].scholarship?.name ??
                                        '');
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: screenHeight * 0.075,
                    left: 16,
                    child: BackButtonCircle(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
