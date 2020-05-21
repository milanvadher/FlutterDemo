import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static setup() {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_stat_ic_notification');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      androidInitializationSettings,
      iosInitializationSettings,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  static Future<dynamic> onSelectNotification(String payload) async {
    Fluttertoast.showToast(
      msg: 'Payload: $payload',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
    return Future<void>.value();
  }

  static Future showBasicNotification({
    @required int id,
    @required String title,
    @required String body,
    Color primaryColor,
    bool playSound = true,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'information',
      'Information',
      'User notify about some information',
      importance: Importance.Default,
      priority: Priority.High,
      color: primaryColor,
      autoCancel: true,
      playSound: playSound,
      enableVibration: true,
      // maxProgress: 100,
      // progress: 40,
      // showProgress: false,
      // onlyAlertOnce: true,
      category: 'CATEGORY_REMINDER',
      ongoing: false,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  static Future showProgressNotification({
    @required int id,
    @required String title,
    @required String body,
    Color primaryColor,
    @required int curruntProgress,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'progress',
      'Progress',
      'User notify about some progress',
      importance: Importance.Default,
      priority: Priority.High,
      color: primaryColor,
      playSound: true,
      enableVibration: true,
      maxProgress: 100,
      progress: curruntProgress,
      showProgress: true,
      onlyAlertOnce: true,
      category: 'CATEGORY_PROGRESS',
      ongoing: true,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  static Future clearAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  
  static Future clearNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
