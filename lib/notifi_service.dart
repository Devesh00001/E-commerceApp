import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider_example/cart_page.dart';
import 'package:provider_example/stripe_payment_service.dart';
import 'package:provider_example/utils.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin notificationService =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context, message) async {
    AndroidInitializationSettings initializationAndroidSetting =
        const AndroidInitializationSettings('icon_flutter');

    var intializationSettingsIOS = const DarwinInitializationSettings();

    var intializationSettings = InitializationSettings(
        android: initializationAndroidSetting, iOS: intializationSettingsIOS);

    await notificationService.initialize(intializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(context, message);
    });
  }

  Future<void> requestNotificationPermission() async {
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

  Future<void> showNotification(RemoteMessage message) async {
    //for ios
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    //for Android
    AndroidNotificationDetails androidNotificationDetails;

    //data has images
    if (message.data['bigimage'] != null &&
        message.data['largeimage'] != null) {
      //download image
      final largeIconPath = await Utils.downloadFile(
        message.data['largeimage'],
        'largeIcon',
      );

      //download image
      final bigPicturePath = await Utils.downloadFile(
        message.data['bigimage'],
        'BigPicher',
      );
      print(message.notification!.android!.channelId.toString());
      final styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath));

      //Android notification channel
      AndroidNotificationChannel channel = AndroidNotificationChannel(
          message.notification!.android!.channelId.toString(),
          message.notification!.android!.channelId.toString(),
          importance: Importance.max,
          showBadge: true,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));

      //Android notifcation details
      androidNotificationDetails = AndroidNotificationDetails(
          channel.id.toString(), channel.name.toString(),
          importance: Importance.max,
          icon: "icon_flutter",
          styleInformation: styleInformation,
          priority: Priority.max);
    } else {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
          message.notification!.android!.channelId.toString(),
          message.notification!.android!.channelId.toString(),
          importance: Importance.max,
          showBadge: true,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));

      androidNotificationDetails = AndroidNotificationDetails(
          channel.id.toString(), channel.name.toString(),
          importance: Importance.max,
          icon: "icon_flutter",
          priority: Priority.max);
    }
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    notificationService.show(0, message.notification!.title.toString(),
        message.notification!.body.toString(), notificationDetails);
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

  void firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data['page']);
      if (Platform.isAndroid) {
        print("android");
        initNotification(context, message);
        showNotification(message);
      }
      showNotification(message);
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is terminated
    RemoteMessage? intialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (intialMessage != null) {
      // ignore: use_build_context_synchronously
      handleMessage(context, intialMessage);
    }

    //when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  //ontap on notification when app is open
  void handleMessage(BuildContext context, RemoteMessage message) {
    final StripePayment = StripePaymentService();
    if (message.data['page'] == 'order') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CartPage(
                    StripePaymentS: StripePayment,
                  )));
    }
  }
}
