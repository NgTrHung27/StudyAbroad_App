import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kltn_mobile/main.dart';

// Tạo kênh thông báo với mức độ quan trọng cao
AndroidNotificationChannel createNotificationChannel() {
  return const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
}

// Khởi tạo plugin thông báo cục bộ
FlutterLocalNotificationsPlugin initializeLocalNotificationsPlugin() {
  return FlutterLocalNotificationsPlugin();
}

// Xử lý thông báo nền
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final AndroidNotificationChannel channel = createNotificationChannel();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    initializeLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: (id, title, body, payload) async {
            // Handle notification tapped logic here
          });

  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> setupNotificationChannel() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// //Handle Noti we received
// // Function to handle Received Mess
void handleMessage(RemoteMessage? message) {
  try {
    if (message == null) {
      navigatorKey.currentState?.pushNamed(
        '/mainpage',
        arguments: {'message': {}, 'index': 2},
      );
      return;
    }
    navigatorKey.currentState?.pushNamed(
      '/mainpage',
      arguments: {'message': message, 'index': 2},
    );
  } catch (e) {
    print('Error handling message: $e');
  }
}

//ListenMess
Future<void> listenToForegroundMessages() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/launcher_icon',
          ),
        ),
      );
    }
  });
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

// Đảm bảo hàm này được gọi để xử lý thông báo nền
void setupFirebaseMessagingBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
