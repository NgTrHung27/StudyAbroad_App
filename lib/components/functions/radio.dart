import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';

class CustomRadio<T> extends StatelessWidget {
  final T value;
  final String title;

  const CustomRadio({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Expanded(
      child: SizedBox(
        height: 37,
        child: RadioListTile<T>(
          title: Text(
            title,
            style: GoogleFonts.getFont(
              'Montserrat',
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          value: value,
          dense: true,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
