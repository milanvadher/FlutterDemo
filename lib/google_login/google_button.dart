import 'package:flutter/material.dart';
import '../settings.bloc.dart';
import 'auth.service.dart';

class GoogleButton {
  Widget googleButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RaisedButton(
          padding: EdgeInsets.only(right: 10),
          color: SettingsBloc.isDarkTheme.value ? Colors.blue : Colors.white,
          onPressed: AuthService.signInWithGoogle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/google.png',
                height: 40,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Sign in with Google'),
            ],
          ),
        ),
      ],
    );
  }
}
