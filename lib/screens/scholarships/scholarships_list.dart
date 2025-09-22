import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/repository/repository.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/functions/circle_avatarimg.dart';
import 'package:kltn_mobile/components/list_view/scholarships_box.dart';
import 'package:kltn_mobile/models/schools.dart' as schools;
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';

class ScholarshipsList extends BasePage {
  const ScholarshipsList({super.key});
  @override
  ScholarshipsListState createState() => ScholarshipsListState();
}

class ScholarshipsListState extends BasePageState<ScholarshipsList> {
  Future<List<schools.SchoolScholarship>> fetchScholarships() async {
    final userAuth = context.read<UserAuthProvider>().userAuthLogin;
    if (userAuth != null) {
      final schoolId = userAuth.student.school.id;
      final apiRepository = APIRepository();
      final schoolsList = await apiRepository.fetchSchools();

      final school = schoolsList.firstWhere(
        (school) => school.id == schoolId,
        orElse: () => schools.Schools(
          id: '',
          name: 'Default Name', // Cung cấp giá trị mặc định cho name
          logo: 'default_logo.png', // Cung cấp giá trị mặc định cho logo
          color: 'default_color', // Cung cấp giá trị mặc định cho color
          background: 'default_background.png', // Cung cấp giá trị mặc định cho background
          isPublished: false, // Cung cấp giá trị mặc định cho isPublished
          country: 'default_country', // Cung cấp giá trị mặc định cho country
          locations: [], // Cung cấp giá trị mặc định cho locations
          programs: [], // Cung cấp giá trị mặc định cho programs
          createdAt: DateTime.now(), // Cung cấp giá trị mặc định cho createdAt
          updatedAt: DateTime.now(), // Cung cấp giá trị mặc định cho updatedAt
          scholarships: [], // Cung cấp giá trị mặc định cho scholarships
          news: [], // Cung cấp giá trị mặc định cho news
        ),
      );
      final publishedScholarships = school.scholarships?.where((scholarship) => scholarship.isPublished).toList() ?? [];
      return publishedScholarships;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final schonull = localizations != null ? localizations.schlar_null : "Default Text";
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Stack(
          children: [
            FutureBuilder<List<schools.SchoolScholarship>>(
              future: fetchScholarships(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.14),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(userAuth?.student.school.background ?? ''),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: TextMonserats(
                                userAuth?.student.school.name ?? '',
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Container(
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
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  );
                } else {
                  final scholarships = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.14),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(userAuth?.student.school.background ?? ''),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: TextMonserats(
                                userAuth?.student.school.name ?? '',
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ScholarshipsBox(
                            scholarships: scholarships,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              child: const BackButtonCircle(), // Đặt BackButtonCircle ở góc trái trên
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              right: 0,
              child: CirleAvatarImage(
                  avatarImgUrl: userAuth?.student.school.logo != null ? userAuth!.student.school.logo : null,
                  avatarImgPath: 'assets/logo/logo_red.png',
                  width: 60,
                  height: 60),
            ),
          ],
        ),
      ),
    );
  }
}
