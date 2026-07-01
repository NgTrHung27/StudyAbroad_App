import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/widgets/major_box.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/widgets/news_listview_horizontal.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/widgets/scholar_school_box.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/components/functions/safe_network_image.dart';

class SchoolsDetail extends StatefulWidget {
  final SchoolEntity school;
  const SchoolsDetail({super.key, required this.school});

  @override
  SchoolsDetailState createState() => SchoolsDetailState();
}

class SchoolsDetailState extends State<SchoolsDetail> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final schoolnameColor = isDarkMode ? Colors.white : AppColor.redButton;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final scaffoldBackgroundColor =
        isDarkMode ? AppColor.scafflodBgColorDark : Colors.white;
    return Scaffold(
      body: Stack(children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SafeNetworkImage(
                      url: widget.school.background, fit: BoxFit.cover),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5 -
                          screenWidth * 0.5),
                  width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextMonserats(widget.school.name,
                        fontWeight: FontWeight.w700,
                        color: schoolnameColor,
                        fontSize: screenWidth * 0.07,
                        height: 1.3),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TabBar(
                            isScrollable: true,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03),
                            tabAlignment: TabAlignment.start,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                color: schoolnameColor,
                                width: 2.0,
                              ),
                            ),
                            tabs: [
                              Tab(
                                  child: TextMonserats(
                                schDescKey.tr(),
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: schoolnameColor,
                              )),
                              // Tab(
                              //     child: TextMonserats(
                              //   schReq,
                              //   fontSize: screenWidth * 0.04,
                              //   fontWeight: FontWeight.bold,
                              //   color: schoolnameColor,
                              // )),
                              Tab(
                                  child: TextMonserats(
                                schMajorKey.tr(),
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: schoolnameColor,
                              )),
                              Tab(
                                  child: TextMonserats(
                                schScholarshipKey.tr(),
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: schoolnameColor,
                              )),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.35,
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: TextMonserats(
                                    widget.school.description ?? '',
                                    fontSize: 16.0,
                                    color: textColor,
                                  ),
                                ),
                                // const Center(child: Text('Courses Content')),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: screenHeight * 0.02,
                                          bottom: screenHeight * 0.02),
                                      child: TextMonserats(
                                          '${schMajorBodyKey.tr()} ${widget.school.name}',
                                          fontWeight: FontWeight.w700,
                                          color: schoolnameColor,
                                          fontSize: screenWidth * 0.05,
                                          height: 1.3),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: MajorBox(
                                            programs:
                                                widget.school.programs ?? []),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: screenHeight * 0.02,
                                          bottom: screenHeight * 0.02),
                                      child: TextMonserats(
                                          'Scholarships of ${widget.school.name}',
                                          fontWeight: FontWeight.w700,
                                          color: schoolnameColor,
                                          fontSize: screenWidth * 0.05,
                                          height: 1.3),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: ScholarSchoolBox(
                                            scholar:
                                                widget.school.scholarships ??
                                                    []),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextMonserats('School News',
                              fontWeight: FontWeight.w700,
                              color: schoolnameColor,
                              fontSize: screenWidth * 0.04,
                              height: 1.3),
                          // Danh sách tin tức
                          SizedBox(height: screenHeight * 0.02),
                          const NewsListView(
                            nullSchool: null,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
              ],
            ),
          ],
        ),
        Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.01,
            child: const BackButtonCircle()),
      ]),
    );
  }
}
