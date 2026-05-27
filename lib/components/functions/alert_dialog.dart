import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showCustomDialog({
  required BuildContext context,
  String? title,
  String? content,
  String? confirmText,
  bool showCancel = true,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
}) {
  final String notiTitle = notiTitleKey.tr();
  final String notiContent = notiContentKey.tr();
  final String notiCancel = notiCancelKey.tr();
  final String notiOk = registerSignInKey.tr();
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Builder(// Sử dụng Builder để tạo context mới
            builder: (BuildContext newContext) {
          return AlertDialog(
            title: TextMonserats(title ?? notiTitle,
                color: AppColor.redButton,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                textAlign: TextAlign.center),
            content: TextMonserats(
              content ?? notiContent,
              textAlign: TextAlign.center,
            ),
            backgroundColor: newContext.select(
                (ThemeSettingBloc bloc) => bloc.state.scaffoldBackgroundColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actions: <Widget>[
              if (showCancel)
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
                  width: showCancel ? 120 : 160,
                  color: AppColor.redButton,
                  child: TextMonserats(
                    confirmText ?? notiOk,
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
