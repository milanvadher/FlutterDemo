import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/notification/local_notification.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseNotification {
  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static final Firestore firestore = Firestore.instance;

  static setup() async {
    // Get the token for this device
    String token;
    if (Platform.isIOS) {
      await _fcm.requestNotificationPermissions();
      token = await _fcm.getToken();
    } else {
      token = await _fcm.getToken();
    }
    saveToken(token);
  }

  static saveToken(String token) async {
    if (AuthService.user.value.uid != null) {
      await firestore
          .collection(AuthService.userTableName)
          .document(AuthService.user.value.uid)
          .collection('tokens')
          .document('device_token')
          .setData({
        'token': token,
        'platform': Platform.operatingSystem,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static configure() async {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showToast('onMessage ${message.toString()}');
        LocalNotification.showBasicNotification(
          id: 1,
          body: (message['notification']).toString(),
          title: 'Title',
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showToast('onLaunch ${message.toString()}');
      },
      onResume: (Map<String, dynamic> message) async {
        showToast('onResume ${message.toString()}');
      },
    );
  }

  static unRegister() async {
    await _fcm.deleteInstanceID();
    await saveToken(null);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
