import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

/// App color constants
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = AppColor.redError;
  static const Color primaryLight = AppColor.redLight;
  static const Color primaryDark = AppColor.redDark;

  // Secondary colors
  static const Color secondary = AppColor.bluePrimary;
  static const Color secondaryLight = AppColor.blueAccent;
  static const Color secondaryDark = AppColor.blueDark;

  // Neutral colors
  static const Color white = Colors.white;
  static const Color black = AppColor.black;
  static const Color grey50 = AppColor.whiteBackground;
  static const Color grey100 = AppColor.grey50;
  static const Color grey200 = AppColor.grey100;
  static const Color grey300 = AppColor.grey200;
  static const Color grey400 = AppColor.grey300;
  static const Color grey500 = AppColor.grey400;
  static const Color grey600 = AppColor.grey500;
  static const Color grey700 = AppColor.grey600;
  static const Color grey800 = AppColor.grey800;
  static const Color grey900 = AppColor.grey900;

  // Semantic colors
  static const Color success = AppColor.greenSuccess;
  static const Color warning = AppColor.yellowWarning;
  static const Color error = AppColor.redAccent;
  static const Color info = AppColor.blueLight;

  // Background colors
  static const Color backgroundLight = AppColor.grey50;
  static const Color backgroundDark = AppColor.grey900;
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = AppColor.grey800;

  // Text colors
  static const Color textPrimaryLight = AppColor.grey900;
  static const Color textSecondaryLight = AppColor.grey500;
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = AppColor.grey300;
}

/// App text styles
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
  );
}

/// App spacing constants
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// App border radius constants
class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double circular = 100;
}
