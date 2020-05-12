import 'package:flutter/material.dart';
import 'package:flutter_demo/settings.bloc.dart';
import 'package:flutter_demo/theme.dart';
import 'home.dart';

void main() {
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
              ? ThemeData.from(colorScheme: AppTheme.darkTheme)
              : ThemeData.from(colorScheme: AppTheme.lightTheme),
        );
      },
    );
  }
}
