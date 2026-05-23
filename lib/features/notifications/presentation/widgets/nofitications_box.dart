import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/models/notifications.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/base_lang.dart';
import 'package:study_abroad_cemc_mobile/features/notifications/presentation/pages/notifications_detail.dart';

class NotificationBox extends BasePage {
  final Notifications notification;

  const NotificationBox({super.key, required this.notification});

  @override
  NotificationBoxState createState() => NotificationBoxState();
}

class NotificationBoxState extends BasePageState<NotificationBox> {
  late ThemeSettingBloc themeSettingBloc;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    themeSettingBloc = context.read<ThemeSettingBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;
    final titleAndTimeColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;

    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NotificationDetailPage(notification: widget.notification),
            ),
          );
        },
        child: SizedBox(
          width: screenWidth,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              color: boxColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(widget.notification.schoolAvt ?? ''),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextMonserats(
                                  widget.notification.schoolName ?? '',
                                  color: textColorRed,
                                  fontSize: 14,
                                ),
                                TextMonserats(widget.notification.time ?? '',
                                    fontSize: 11,
                                    color: titleAndTimeColor,
                                    fontWeight: FontWeight.w500),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: TextMonserats(
                                widget.notification.notiTitle ?? '',
                                fontWeight: FontWeight.w500,
                                color: titleAndTimeColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
