import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/notification/local_notification.dart';
import 'package:rxdart/subjects.dart';

class LocalNotificationDemo extends StatefulWidget {
  @override
  _LocalNotificationDemoState createState() => _LocalNotificationDemoState();
}

class _LocalNotificationDemoState extends State<LocalNotificationDemo> {
  BehaviorSubject<int> progress = BehaviorSubject();
  StreamSubscription streamSubscription;

  void notificationWithSound() {
    LocalNotification.showBasicNotification(
      id: 0,
      title: 'Test Notification',
      body: 'Notification with sound',
      primaryColor: Theme.of(context).primaryColor,
    );
  }

  void notificationWithoutSound() {
    LocalNotification.showBasicNotification(
      id: 1,
      title: 'Test Notification',
      body: 'Notification without sound',
      primaryColor: Theme.of(context).primaryColor,
      playSound: false,
    );
  }

  void notificationWithProgress() async {
    listenProgess();
    await startProgress();
    progressFinish();
  }

  void listenProgess() {
    streamSubscription = progress.listen((value) {
      LocalNotification.showProgressNotification(
        id: 2,
        title: 'Test Notification',
        body: 'Progress is running',
        primaryColor: Theme.of(context).primaryColor,
        curruntProgress: value,
      );
    });
  }

  void progressFinish() async {
    await Future.delayed(Duration(seconds: 1));
    await LocalNotification.clearNotification(2);
    LocalNotification.showBasicNotification(
      id: 2,
      title: 'Progress complete',
      body: 'Your progress is completed',
      playSound: false,
      primaryColor: Theme.of(context).primaryColor,
    );
  }

  startProgress() async {
    for (var i = 1; i <= 100; i += 10) {
      await Future.delayed(Duration(seconds: 1));
      progress.sink.add(i);
    }
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
    progress.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notification Demo'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            RaisedButton(
              child: Text('Show notification with sound'),
              onPressed: notificationWithSound,
            ),
            RaisedButton(
              child: Text('Show notification without sound'),
              onPressed: notificationWithoutSound,
            ),
            RaisedButton(
              child: Text('Show progress in notification'),
              onPressed: notificationWithProgress,
            ),
            RaisedButton(
              child: Text('Cancel all notification'),
              onPressed: LocalNotification.clearAllNotification,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
