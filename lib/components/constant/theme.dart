import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.scafflodBgColor,
    primaryColor: AppColor.scafflodBgColor,
    colorScheme: const ColorScheme.light().copyWith(
      secondary: AppColor.scafflodBgColor,
      // Màu tùy chỉnh cho light theme
    ),
  );
  static ThemeData blackTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.scafflodBgColorDark,
    primaryColor: AppColor.scafflodBgColorDark,
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: AppColor.scafflodBgColorDark, // Màu tùy chỉnh cho light theme
    ),
  );
}
