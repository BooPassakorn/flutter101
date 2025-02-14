import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:workshop/core/config/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message: ${message.notification!.body}");
}

class FCMNotification {
  static init() async {
    //FCM Token
    FirebaseMessaging.instance
        .getToken()
        .then((value) => print('FCM Token : ${value}'));

    //Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message recieved");
      print('Foreground message ${message.notification!.body}');
    });

    //Background message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// จัดการ FCM เมื่อกดที่ Notification บน Status bar
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }
}

class PushNotificationService {
  Future<void> init() async {
    // TODO : Do stuff with background notidication click
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    _onNotificationClicked(initialMessage);

    // TODO : View FCM Token
    FirebaseMessaging.instance.getToken().then((value) {
      if (kDebugMode) {
        print('FCM Token : $value');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onNotificationClicked(initialMessage);
    });

    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  _onNotificationClicked(RemoteMessage? message) {
    if(message != null) {
      switch (message.data['type']) {
        case 'nearbyStore': {
          Get.toNamed(Routes.nearbyStorePage);
        }
        break;
        case 'cart': {
          Get.toNamed(Routes.shoppingCartPage);
        }
        break;
      }
    }
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    var androidSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");

    var iOSSettings = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    RemoteMessage? recentMessage;

    // TODO : Do stuff with foreground notification received (Terminated state)
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      recentMessage = message;
      _showNotification(
        flutterLocalNotificationsPlugin, channel, recentMessage);
    });

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // TODO : Do stuff with Background notification received (Terminated state)
      // App received a notification when it was killed
      // If initialMessage != null , construct our own
      // local notification to show to users using the created channel,
      _showNotification(
          flutterLocalNotificationsPlugin, channel, initialMessage);
    }

    var initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveBackgroundNotificationResponse: (message) async { //onSelectNotification
          // TODO : Do stuff with Foreground notification click (Foreground state)
          // TODO : ข้อสังเกตจากการทดสอบเองคืนใน IOS ไม่ว่าจะเป็นการทำงาน Background / Foreground จะไม่เข้าฟังก์ชันนี้แต่จะเข้า FirebaseMessaging.onMessageOpenedApp แทน | ใน Android ทำงานปกติ
          // This function handles the click in the notification when the app is in foreground

          _onNotificationClicked(recentMessage);
        },
    );
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        "high_importance_channel",
        "High Importance Notifications", //title
        description: 'This channel is used for important notifications.',
    importance: Importance.max,
      );

  void _showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      AndroidNotificationChannel channel,
      RemoteMessage? message) {

    if (kDebugMode) {
      print(message);
    }

    RemoteNotification? notification = message!.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        ),
      );
    }
  }
}
