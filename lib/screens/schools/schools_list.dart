import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/schools_cubit/schools_cubit.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/simplebutton.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/list_view/school_box.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kltn_mobile/screens/schools/compare_schools.dart';

class SchoolsListPage extends BasePage {
  const SchoolsListPage({super.key, required this.country});
  final String country;

  @override
  State<SchoolsListPage> createState() => _SchoolsListPageState();
}

class _SchoolsListPageState extends State<SchoolsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolsCubit>().getSchoolListByCountry(widget.country);
  }

  Color getColorForCountry(String country) {
    switch (country.toUpperCase()) {
      case 'CANADA':
        return AppColor.redButton;
      case 'AUSTRALIA':
        return const Color(0xff2D3D7A);
      case 'KOREA':
        return const Color(0xff2BB6CF);
      default:
        return Colors.grey; // Default color if country is not matched
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final exploreColor = isDarkMode ? Colors.white : AppColor.redButton;
    final localizations = AppLocalizations.of(context);
    final schExplore =
        localizations != null ? localizations.sch_explore : 'Default Text';
    final schCanada =
        localizations != null ? localizations.sch_Canada : 'Default Text';
    final schAustra =
        localizations != null ? localizations.sch_Australia : 'Default Text';
    final schKorea =
        localizations != null ? localizations.sch_Korea : 'Default Text';
    final errorConn =
        localizations != null ? localizations.error_connection : "Defalut Text";
    final schRvallSch =
        localizations != null ? localizations.sch_RvAllSch : 'Default Text';
    final schDisMore =
        localizations != null ? localizations.sch_DisMore : 'Default Text';
    String countryText;
    switch (widget.country.toUpperCase()) {
      case 'CANADA':
        countryText = schCanada;
        break;
      case 'AUSTRALIA':
        countryText = schAustra;
        break;
      case 'KOREA':
        countryText = schKorea;
        break;
      default:
        countryText = 'Default Text';
    }

    return Scaffold(
      body: BlocBuilder<SchoolsCubit, SchoolsState>(
        builder: (context, state) {
          if (state is SchoolsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SchoolsLoaded) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
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
                            schRvallSch,
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
                              schDisMore,
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
                            schExplore,
                            color: exploreColor,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08),
                        child: ListView.builder(
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
                  Positioned(
                      top: screenHeight * 0.06,
                      left: screenWidth * 0.03,
                      child: const BackButtonCircle()),
                ],
              ),
            );
          } else if (state is SchoolsError) {
            return Center(child: Text(errorConn));
          }
          return const Center(child: Text('Please wait...'));
        },
      ),
    );
  }
}
