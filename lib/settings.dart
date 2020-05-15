import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/settings.bloc.dart';
import 'google_login/auth.service.dart';
import 'google_login/google_button.dart';

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
        title,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  Widget themeSetting() {
    return ListTile(
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
    );
  }

  Widget userProfile(FirebaseUser user) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Container(
                    child: Center(
                      child: Hero(
                        tag: 'profile_pic',
                        child: Image(
                          image: NetworkImage(user.photoUrl),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 10, top: 5),
              child: Hero(
                tag: 'profile_pic',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 60,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              user.displayName,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              user.email,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Container(
            child: OutlineButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 5),
                  Text('Signout'),
                ],
              ),
              onPressed: AuthService.signOutGoogle,
            ),
          ),
        ],
      ),
    );
  }

  Widget userSetting() {
    return StreamBuilder(
      stream: AuthService.user,
      builder: (
        context,
        AsyncSnapshot<FirebaseUser> snapshot,
      ) {
        if (snapshot.hasData) {
          return userProfile(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error),
          );
        }
        return Container(
          margin: EdgeInsets.all(10),
          child: Center(
            child: GoogleButton().googleButton(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    AuthService.checkUserLoginStatus();
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
            userSetting(),
            Divider(),
            heading('Basics'),
            themeSetting(),
          ],
        ),
      ),
    );
  }
}
