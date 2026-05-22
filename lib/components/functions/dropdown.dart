import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

class DropdownCustom<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String hintText;
  final Function(T?) onChanged;
  final String Function(T) itemLabel;
  final bool isExpanded;
  final IconData? icon;
  final Color? color;
  final String? errorText;

  const DropdownCustom({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemLabel,
    required this.hintText,
    required this.isExpanded,
    this.icon,
    this.color,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundDropdown = isDarkMode ? AppColor.scafflodBgColorDark : Colors.white;
    return SizedBox(
      height: 43,
      child: DropdownButtonFormField<T>(
        hint: Text(
          hintText,
          style: GoogleFonts.montserrat(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        iconSize: 24,
        icon: Icon(
          Icons.arrow_drop_down,
          color: iconColor,
        ),
        initialValue: selectedItem,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              itemLabel(value),
              style: GoogleFonts.montserrat(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        isExpanded: isExpanded,
        decoration: InputDecoration(
          //error
          errorText: errorText,
          errorStyle: GoogleFonts.montserrat(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red, style: BorderStyle.solid, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          prefixIcon: Icon(
            icon ?? Icons.map,
            color: color ?? iconColor,
            size: 20,
          ),
          filled: true,
          fillColor: backgroundDropdown,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 11),
        ),
      ),
    );
  }
}
