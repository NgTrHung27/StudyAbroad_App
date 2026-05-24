import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_schools_usecase.dart';
import 'package:study_abroad_cemc_mobile/components/Style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/Style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/widgets/scholarships_box.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/models/schools.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';

class ScholarshipsListPage extends StatefulWidget {
  const ScholarshipsListPage({super.key});
  @override
  ScholarshipsListPageState createState() => ScholarshipsListPageState();
}

class ScholarshipsListPageState extends State<ScholarshipsListPage> {
  Future<List<SchoolScholarship>> fetchScholarships() async {
    final userAuth = context.read<UserAuthProvider>().userAuthLogin;
    if (userAuth != null) {
      final schoolId = userAuth.student?.school.id;
      final getSchoolsUseCase = getIt<GetSchoolsUseCase>();
      final result = await getSchoolsUseCase();

      return result.fold(
        (failure) => [],
        (schoolsList) {
          for (final schoolEntity in schoolsList) {
            if (schoolEntity.id == schoolId) {
              final scholarships = schoolEntity.scholarships;
              if (scholarships != null) {
                return scholarships
                    .where((s) => s.isPublished)
                    .map((entity) => SchoolScholarship(
                          id: entity.id,
                          name: entity.name,
                          description: entity.description,
                          cover: entity.cover,
                          isPublished: entity.isPublished,
                          schoolId: schoolId ?? '',
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ))
                    .toList();
              }
              return <SchoolScholarship>[];
            }
          }
          return <SchoolScholarship>[];
        },
      );
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.red, AppColor.backgrTabLight],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    BackButtonCircle(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                    TextMonserats(
                      schScholarshipKey.tr(),
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    const Spacer(),
                    Container(width: 35),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.backgrTabLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FutureBuilder<List<SchoolScholarship>>(
                      future: fetchScholarships(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: TextMonserats(
                              snapshot.error.toString(),
                              color: Colors.red,
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: TextMonserats(
                              scholarNullKey.tr(),
                              fontSize: screenWidth * 0.04,
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          return ScholarshipsBox(
                            scholarships: snapshot.data!,
                          );
                        }
                      },
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
