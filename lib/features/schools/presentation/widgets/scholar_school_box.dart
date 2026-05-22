import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/Style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/scholar_detail.dart';

class ScholarSchoolBox extends StatefulWidget {
  final List<SchoolScholarshipEntity> scholar;
  const ScholarSchoolBox({super.key, required this.scholar});

  @override
  ScholarSchoolBoxState createState() => ScholarSchoolBoxState();
}

class ScholarSchoolBoxState extends State<ScholarSchoolBox> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? const Color(0xff3F3F46) : Colors.white;
    return ListView.builder(
      itemCount: widget.scholar.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ScholarDetailPage(scholar: widget.scholar[index])),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: isDarkMode ? Colors.white : Colors.black),
            ),
            child: TextMonserats(
              widget.scholar[index].name,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        );
      },
    );
  }
}
