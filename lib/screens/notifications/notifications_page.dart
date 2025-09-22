import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/news_searchtextfield.dart';
import 'package:kltn_mobile/components/functions_main_page/hello_avt.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/components/list_view/noti_list.dart';
import 'package:kltn_mobile/models/notifications.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class NotificationsPage extends BasePage {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends BasePageState<NotificationsPage> {
  List<Notifications> notifications = [];

  @override
  void initState() {
    super.initState();
    context.read<ThemeSettingCubit>().loadTheme();
    _loadNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        final newNotification = Notifications(
          schoolAvt:
              'https://images.pexels.com/photos/1366630/pexels-photo-1366630.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          schoolName: 'Huflit America',
          notiTitle: message.notification?.title,
          notiContent: message.notification?.body,
          time: DateTime.now().toString(),
        );
        notifications.add(newNotification);
        await Notifications.saveNotifications(notifications);
        setState(() {}); // Cập nhật giao diện người dùng
      }
    });
  }

  Future<void> _loadNotifications() async {
    notifications = await Notifications.loadNotifications();
    setState(() {}); // Cập nhật giao diện người dùng
  }

  Future<void> _clearNotifications() async {
    notifications.clear();
    await Notifications.saveNotifications(notifications);
    setState(() {}); // Cập nhật giao diện người dùng
  }

  void checkUserAuthAndClearNotifications() {
    final userAuth = context.read<UserAuthProvider>().userAuthLogin;
    if (userAuth == null) {
      _clearNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Language
    final localizations = AppLocalizations.of(context);
    final notidelete = localizations != null ? localizations.noti_dele : 'Default Text';
    return Scaffold(
      backgroundColor: context.select((ThemeSettingCubit cubit) => cubit.state.scaffoldBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
        child: ListView(children: [
          WelcomeAVT(username: userAuth?.name ?? 'User'),
          SizedBox(height: screenHeight * 0.01),
          const NewsSearchTextField(),
          SizedBox(height: screenHeight * 0.04),
          Transform.translate(
            offset: const Offset(0, -15),
            child: GestureDetector(
              onTap: _clearNotifications,
              child: Text(
                notidelete,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          ListNoti(
            notifications: notifications,
          ),
        ]),
      ),
    );
  }
}
