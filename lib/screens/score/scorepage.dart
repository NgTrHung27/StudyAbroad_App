import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/models/user_login.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/screens/score/scoredetail.dart';

class ScorePage extends BasePage {
  const ScorePage({super.key});

  @override
  ScorePageState createState() => ScorePageState();
}

class ScorePageState extends BasePageState<ScorePage> {
  late int latestSemester;

  @override
  void initState() {
    super.initState();
    latestSemester =
        userAuth?.student.program?.scores?.map((e) => int.parse(e.semester)).reduce((a, b) => a > b ? a : b) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    List<Score>? scores = userAuth?.student.program?.scores;

    Score? latestScore;
    List<Score> previousScores = [];

    if (scores != null && scores.isNotEmpty) {
      // Đảo ngược danh sách scores để item nào thêm sau thì hiển thị ở trên
      scores = scores.reversed.toList();
      // Lấy giá trị đầu tiên của danh sách để hiển thị ở phần "Latest Score"
      latestScore = scores.first;
      // Lấy các giá trị còn lại của danh sách để hiển thị ở phần "Previous Score"
      previousScores = scores.skip(1).toList();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : AppColor.redButton;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.15,
              color: AppColor.redButton,
              child: Padding(
                padding: EdgeInsets.only(top: screenWidth * 0.05),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButtonCircle(),
                        TextMonserats(
                          'Score',
                          color: Colors.white,
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(
                          width: screenWidth * 0.13,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextMonserats(
                    'Latest Score',
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  SizedBox(height: screenHeight * 0.013),
                  if (latestScore == null)
                    Center(
                      child: TextMonserats(
                        'No scores available',
                        fontSize: screenWidth * 0.04,
                        color: Colors.red,
                      ),
                    )
                  else
                    Card(
                      color: Colors.white,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: TextMonserats(
                                      'Semester ${latestScore.semester}',
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle download action
                                  },
                                  icon: const Icon(Icons.download_for_offline_outlined),
                                  label: TextMonserats(
                                    'Download',
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.033,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextMonserats(
                                  'Total GPA',
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                                TextMonserats(
                                  calculateGPA(latestScore.subjects).toStringAsFixed(1),
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[800],
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.person_outline,
                                color: Colors.black,
                              ),
                              title: TextMonserats(
                                'Details score',
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: screenWidth * 0.04,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ScoreDetail(semester: latestScore!.semester, year: latestScore.year),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.03),
                  // ignore: unnecessary_null_comparison
                  if (previousScores.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextMonserats(
                          'Previous Score',
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        SizedBox(height: screenHeight * 0.013),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), // Inner padding for the box
                          decoration: BoxDecoration(
                            color: Colors.white, // White background
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: previousScores.map((semesterScore) {
                                // Get the index of the current item
                                int index = previousScores.indexOf(semesterScore);
                                // Get the total number of items
                                int itemCount = previousScores.length;
                                return Column(
                                  children: [
                                    ListTile(
                                      title: TextMonserats(
                                        'Semester ${semesterScore.semester}',
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.black,
                                      ),
                                      subtitle: TextMonserats(
                                        'Year ${semesterScore.year}',
                                        fontSize: screenWidth * 0.03,
                                        color: Colors.grey,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ScoreDetail(
                                              semester: semesterScore.semester,
                                              year: semesterScore.year,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    // Only show Divider if this is not the last item
                                    if (index < itemCount - 1)
                                      const Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateGPA(List<Subject> subjects) {
    double totalScore = subjects.fold(
      0.0,
      (previousValue, subject) => previousValue + subject.score,
    );
    return totalScore / subjects.length;
  }
}
