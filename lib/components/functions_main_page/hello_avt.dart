import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/components/functions/circle_avatarimg.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class WelcomeAVT extends BasePage {
  const WelcomeAVT({super.key, required this.username});
  final String username;
  @override
  State<WelcomeAVT> createState() => _WelcomeAVTState();
}

class _WelcomeAVTState extends BasePageState<WelcomeAVT> {
  @override
  Widget build(BuildContext context) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;

    final localizations = AppLocalizations.of(context);
    final homeHello = localizations != null ? localizations.home_hello : 'Default Text';
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextMonserats(
              homeHello,
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
                avatarImgUrl: userAuth?.student.school.logo != null ? userAuth!.student.school.logo : null,
                avatarImgPath: 'assets/logo/logo_red.png',
                width: 60,
                height: 60)),
      ],
    );
  }
}
