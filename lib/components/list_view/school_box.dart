import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/models/schools.dart';
import 'package:kltn_mobile/screens/schools/schools_detail.dart';

class SchoolBox extends StatelessWidget {
  final Schools school;
  const SchoolBox({super.key, required this.school});

  // Hàm để chuyển đổi chuỗi rgba thành Color
  Color rgbaToColor(String rgba) {
    final rgbaValues =
        rgba.replaceAll('rgba(', '').replaceAll(')', '').split(',');
    return Color.fromRGBO(
      int.parse(rgbaValues[0].trim()),
      int.parse(rgbaValues[1].trim()),
      int.parse(rgbaValues[2].trim()),
      double.parse(rgbaValues[3].trim()),
    );
  }

  // Hàm để extract và tạo LinearGradient từ chuỗi
  LinearGradient parseGradient(String gradientString) {
    final matches = RegExp(r'rgba\((\d+,\d+,\d+,\d?.?\d*)\)\s(\d+)%')
        .allMatches(gradientString);

    final colors = <Color>[];
    final stops = <double>[];

    for (final match in matches) {
      final color = rgbaToColor(match.group(1)!);
      final stop = double.parse(match.group(2)!) / 100;
      colors.add(color);
      stops.add(stop);
    }

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: stops,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? const Color(0xff3F3F46) : Colors.white;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.015),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SchoolsDetail(school: school)),
          );
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    school.background,
                    height: screenHeight * 0.23,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: parseGradient(school.color).begin,
                          end: parseGradient(school.color).end,
                          stops: parseGradient(school.color).stops,
                          colors: parseGradient(school.color)
                              .colors
                              .map((color) => color.withValues(alpha: 0.35),)
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: screenHeight * 0.3,
                color: boxColor,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextMonserats(
                      school.name,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      height: 1.3,
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: textColor,
                          size: screenWidth * 0.05,
                        ),
                        Expanded(
                          child: TextMonserats(
                            '166-220 Holloway Rd, Australian',
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Expanded(
                      child: TextMonserats(
                        school.short ?? 'no short description',
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                        height: 1.3,
                        overflow: TextOverflow.ellipsis,
                        maxLine: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
