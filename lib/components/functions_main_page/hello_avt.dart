import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/functions/circle_avatarimg.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/screens/home/base_lang.dart';

class WelcomeAVT extends BasePage {
  const WelcomeAVT({super.key, required this.username});
  final String username;
  @override
  State<WelcomeAVT> createState() => _WelcomeAVTState();
}

class _WelcomeAVTState extends BasePageState<WelcomeAVT> {
  @override
  Widget build(BuildContext context) {
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;

    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextMonserats(
              homeHelloKey.tr(),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
            Transform.translate(
              offset: const Offset(0, -5),
              child: TextMonserats(
                widget.username,
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: textColorRed,
              ),
            ),
          ],
        ),
        Transform.translate(
            offset: const Offset(-5, -5),
            child: CirleAvatarImage(
                avatarImgUrl: userAuth?.student?.school.logo != null
                    ? userAuth!.student?.school.logo
                    : null,
                avatarImgPath: 'assets/logo/logo_red.png',
                width: 60,
                height: 60)),
      ],
    );
  }
}
