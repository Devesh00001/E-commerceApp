import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider_example/utils.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin notificationService =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationAndroidSetting =
        const AndroidInitializationSettings('icon_flutter');

    var intializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) {});

    var intializationSettings = InitializationSettings(
        android: initializationAndroidSetting, iOS: intializationSettingsIOS);

    await notificationService.initialize(intializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional authorization");
    } else {
      print("User denied permission");
    }
  }

  Future notificationDetails(String bigPicture, String largesIcon) async {
    if (bigPicture != "" && largesIcon != "") {
      final largeIconPath = await Utils.downloadFile(
        largesIcon,
        'largeIcon',
      );

      final bigPicturePath = await Utils.downloadFile(
        bigPicture,
        'BigPicher',
      );

      final styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath));

      AndroidNotificationChannel channel = AndroidNotificationChannel(
          Random.secure().nextInt(1000000).toString(), "your_channel",
          importance: Importance.max);

      return NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id.toString(), channel.name.toString(),
              importance: Importance.max,
              icon: "icon_flutter",
              styleInformation: styleInformation),
          iOS: const DarwinNotificationDetails());
    } else {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
          Random.secure().nextInt(1000000).toString(), "your_channel",
          importance: Importance.max);

      return NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id.toString(),
            channel.name.toString(),
            importance: Importance.max,
            icon: "icon_flutter",
          ),
          iOS: const DarwinNotificationDetails());
    }
  }

  Future showNotification(RemoteMessage message) async {
    return notificationService.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        await notificationDetails(
            message.data['bigimage'] ?? "", message.data['largeimage'] ?? ""));
  }

  // Future showSecheduleNotification(
  //     {int id = 0, String? title, String? body, String? payLoad}) async {
  //   return notificationService.periodicallyShow(id, title, body,
  //       RepeatInterval.everyMinute, await notificationDetails(message.data['bigimage'], message.data['largeimage']));
  // }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void firebaseInit() async {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      showNotification(message);
    });
  }
}
