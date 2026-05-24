import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/Style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/Style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/action/id_tab.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/widgets/scholar_box.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:shimmer/shimmer.dart';

class ScholarDetail extends StatefulWidget {
  const ScholarDetail({super.key});

  @override
  ScholarDetailState createState() => ScholarDetailState();
}

class ScholarDetailState extends State<ScholarDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserAuthProvider>().fetchFreshProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAuthProvider = context.watch<UserAuthProvider>();
    final userAuth = userAuthProvider.userAuthLogin;
    final isFetching = userAuthProvider.isFetchingProfile;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;
    final screenHeight = MediaQuery.of(context).size.height;

    if (userAuth == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<StudentSchoolScholarship>? scholarshipList =
        userAuth.student?.scholarship;

    return Scaffold(
        body: Stack(
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
              child: isFetching
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: IdTab(
                        userName: 'Loading...',
                        idUser: 'Loading...',
                        avatarImgPath: ImageAssets.logoWhite,
                      ),
                    )
                  : IdTab(
                      userName: userAuth.name ?? 'N/A',
                      idUser: userAuth.email,
                      avatarImgUrl: userAuth.student?.school.logo,
                      avatarImgPath: ImageAssets.logoWhite,
                    ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scholarshipList?.length ?? 0,
                itemBuilder: (context, index) {
                  return ScholarStatusWidget(
                      scholarStatus: scholarshipList![index].status,
                      name: scholarshipList[index].scholarship?.name ?? '');
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
    ));
  }
}
