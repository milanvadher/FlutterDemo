import 'package:flutter/material.dart';
import 'package:flutter_demo/notification/firebase_notification.dart';
import 'package:flutter_demo/settings.bloc.dart';
import 'package:flutter_demo/theme.dart';
import 'home.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'notification/local_notification.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SettingsBloc.setAppThemeOnLoad();
    FirebaseNotification.configure();
    LocalNotification.setup();
  }

  @override
  void dispose() {
    super.dispose();
    SettingsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: SettingsBloc.isDarkTheme,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return MaterialApp(
          title: 'Flutter Demo',
          home: HomePage(),
          theme: snapshot.data
              ? ThemeData.from(
                  colorScheme: AppTheme.darkTheme,
                  textTheme: TextTheme().apply(fontFamily: 'Google'),
                )
              : ThemeData.from(
                  colorScheme: AppTheme.lightTheme,
                  textTheme: TextTheme().apply(fontFamily: 'Google'),
                ),
        );
      },
    );
  }
}
