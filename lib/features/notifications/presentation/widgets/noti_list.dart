import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/functions/circle_avatarimg.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/models/notifications.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/base_lang.dart';
import 'package:study_abroad_cemc_mobile/features/notifications/presentation/pages/notifications_detail.dart';

class ListNoti extends BasePage {
  const ListNoti({super.key, required this.notifications});
  final List<Notifications> notifications;

  @override
  State<ListNoti> createState() => _ListNotiState();
}

class _ListNotiState extends BasePageState<ListNoti> {
  // ignore: unused_field
  List<Notifications> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await Notifications.loadNotifications();
    setState(() {
      _notifications = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;
    final titleAndTimeColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ...widget.notifications.map((noti) {
          DateTime timesend = DateTime.parse(noti.time!);
          Duration difference = DateTime.now().difference(timesend);
          String formattedDate;

          if (difference.inMinutes < 60) {
            formattedDate = '${difference.inMinutes} phút trước';
          } else if (difference.inHours < 24) {
            formattedDate = '${difference.inHours} giờ trước';
          } else {
            formattedDate = DateFormat('dd/MM/yyyy').format(timesend);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetailPage(
                        notification: widget.notifications[0]),
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
                          CirleAvatarImage(
                              avatarImgUrl:
                                  userAuth?.student?.school.logo != null
                                      ? userAuth!.student?.school.logo
                                      : null,
                              avatarImgPath: 'assets/logo/logo_red.png',
                              width: 60,
                              height: 60),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextMonserats(
                                          userAuth?.student?.school.name ??
                                              'CEMC',
                                          color: textColorRed,
                                          fontSize: 14,
                                          maxLine: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      TextMonserats(
                                        formattedDate,
                                        fontSize: 11,
                                        color: titleAndTimeColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: TextMonserats(
                                      noti.notiTitle ?? '',
                                      fontWeight: FontWeight.w500,
                                      color: titleAndTimeColor,
                                      fontSize: 12,
                                      maxLine: 1,
                                      overflow: TextOverflow.ellipsis,
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
        }),
      ],
    );
  }
}
