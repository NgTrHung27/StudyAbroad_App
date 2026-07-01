import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_event.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_state.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/simplebutton.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/widgets/school_box.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/functions/empty_data.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/compare_schools.dart';

typedef SchoolBloc = SchoolsBloc;

class SchoolsListPage extends StatefulWidget {
  const SchoolsListPage({super.key, required this.country});
  final String country;

  @override
  State<SchoolsListPage> createState() => _SchoolsListPageState();
}

class _SchoolsListPageState extends State<SchoolsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolBloc>().add(GetSchoolListByCountryEvent(widget.country));
  }

  Color getColorForCountry(String country) {
    switch (country.toUpperCase()) {
      case 'CANADA':
        return AppColor.redButton;
      case 'AUSTRALIA':
        return AppColor.indigoDark;
      case 'KOREA':
        return AppColor.cyanLight;
      default:
        return Colors.grey; // Default color if country is not matched
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final exploreColor = isDarkMode ? Colors.white : AppColor.redButton;
    String countryText;
    switch (widget.country.toUpperCase()) {
      case 'CANADA':
        countryText = schCanadaKey.tr();
        break;
      case 'AUSTRALIA':
        countryText = schAustraliaKey.tr();
        break;
      case 'KOREA':
        countryText = schKoreaKey.tr();
        break;
      default:
        countryText = '';
    }

    return Scaffold(
      body: BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          if (state is SchoolsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SchoolsLoaded) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight * 0.15,
                        color: getColorForCountry(widget.country),
                        child: Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.03),
                          child: Center(
                            child: TextMonserats(
                              countryText,
                              color: Colors.white,
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08),
                        child: Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.025),
                          child: TextMonserats(
                            schRvAllSchKey.tr(),
                            color: exploreColor,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08),
                        child: Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.025),
                          child: SimpleButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompareSchoolsPage(
                                    schoolNames: state.schoolList
                                        .map((school) => school.name)
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                            backgroundColor: getColorForCountry(widget.country),
                            child: TextMonserats(
                              schDisMoreKey.tr(),
                              color: Colors.white,
                              fontSize: screenWidth * 0.037,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.025),
                          child: TextMonserats(
                            schExploreKey.tr(),
                            color: exploreColor,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08),
                        child: state.schoolList.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 40.0),
                                child: EmptyDataWidget(text: 'Không có trường học nào'),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.schoolList.length,
                                itemBuilder: (context, index) {
                                  final school = state.schoolList[index];
                                  return SchoolBox(school: school);
                                },
                              ),
                      ),
                    ],
                  ),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: const BackButtonCircle()),
                ],
              ),
            );
          } else if (state is SchoolsError) {
            final isNetworkError = state.failure is SchoolsNetworkFailure;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isNetworkError ? Icons.wifi_off : Icons.error_outline,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Please wait...'));
        },
      ),
    );
  }
}
