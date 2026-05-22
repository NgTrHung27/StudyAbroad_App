import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';

// ignore: must_be_immutable
class LegendBox extends StatefulWidget {
  final String title;
  String value;
  final bool isEditable;
  final Color color;

  LegendBox({
    super.key,
    required this.title,
    required this.value,
    this.isEditable = false,
    this.color = Colors.white,
  });

  @override
  State<LegendBox> createState() => _LegendBoxState();
}

class _LegendBoxState extends State<LegendBox> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final titleBox =
        isDarkMode ? AppColor.scafflodBgColorDark : AppColor.scafflodBgColor;
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            height: 65.0,
            constraints: const BoxConstraints(minWidth: double.infinity),
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextMonserats(
                    widget.value,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    color: widget.value == 'APPROVED'
                        ? Colors.green
                        : widget.value == 'DENIED'
                            ? Colors.red
                            : textColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 15.0,
            child: Container(
              color: titleBox,
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: TextMonserats(
                widget.title,
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
