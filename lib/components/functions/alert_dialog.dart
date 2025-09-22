import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showCustomDialog({
  required BuildContext context,
  String? title,
  String? content,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
}) {
  final localizations = AppLocalizations.of(context);
  final String notiTitle = localizations != null ? localizations.noti : 'Default Text';
  final String notiContent = localizations != null ? localizations.noti_1 : 'Default Text';
  final String notiCancel = localizations != null ? localizations.noti_2 : 'Default Text';
  final String notiOk = localizations != null ? localizations.register_login_signin : 'Default Text';
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Builder(// Sử dụng Builder để tạo context mới
            builder: (BuildContext newContext) {
          return AlertDialog(
            // ignore: unnecessary_null_comparison
            title: TextMonserats(title ?? notiTitle,
                color: AppColor.redButton, fontWeight: FontWeight.w700, fontSize: 20, textAlign: TextAlign.center),
            content: TextMonserats(
              notiContent,
              textAlign: TextAlign.center,
            ),
            backgroundColor: newContext.select((ThemeSettingCubit cubit) => cubit.state.scaffoldBackgroundColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actions: <Widget>[
              Transform.translate(
                offset: const Offset(10, 0),
                child: DialogButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onCancel != null) onCancel();
                  },
                  width: 120,
                  color: Colors.grey,
                  child: TextMonserats(
                    notiCancel,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.scafflodBgColorDark,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(-15, 0),
                child: DialogButton(
                  onPressed: () {
                    if (onConfirm != null) onConfirm();
                  },
                  width: 120,
                  color: AppColor.redButton,
                  child: TextMonserats(
                    notiOk,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        });
      });
}
