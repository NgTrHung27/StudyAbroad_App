import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/major_detail.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

class MajorBox extends StatefulWidget {
  final List<SchoolProgramEntity> programs;
  const MajorBox({super.key, required this.programs});

  @override
  MajorBoxState createState() => MajorBoxState();
}

class MajorBoxState extends State<MajorBox> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    return ListView.builder(
      itemCount: widget.programs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MajorDetailPage(program: widget.programs[index])),
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
              widget.programs[index].name,
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
