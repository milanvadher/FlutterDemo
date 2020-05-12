import 'package:flutter/material.dart';
import 'package:flutter_demo/settings.bloc.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget heading(String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Text(
        'Basics',
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          children: <Widget>[
            heading('Basics'),
            ListTile(
              title: Text('Dark theme'),
              trailing: StreamBuilder(
                stream: SettingsBloc.isDarkTheme,
                initialData: false,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return Switch(
                    value: snapshot.data,
                    onChanged: (value) {
                      SettingsBloc.changeTheme(value);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
