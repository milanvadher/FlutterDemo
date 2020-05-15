import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/firebase_chat_demo/chat.service.dart';
import 'package:flutter_demo/firebase_chat_demo/chat_screen.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/google_login/google_button.dart';
import 'package:flutter_demo/google_login/user.model.dart';

class FirebaseChatDemo extends StatefulWidget {
  @override
  _FirebaseChatDemoState createState() => _FirebaseChatDemoState();
}

class _FirebaseChatDemoState extends State<FirebaseChatDemo> {
  StreamSubscription<FirebaseUser> streamSubscription;
  Future<List<User>> fetchUsers;

  loadUsers() async {
    setState(() {
      fetchUsers = FirebaseChat.getUsers();
    });
  }

  initData() async {
    await AuthService.checkUserLoginStatus();
    streamSubscription = AuthService.user.listen((value) {
      if (value != null) {
        loadUsers();
      }
    });
  }

  Widget userList(List<User> users) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: users.length,
      itemBuilder: (context, index) {
        User user = users[index];
        return ListTile(
          leading: Hero(
            tag: user.uid,
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
          ),
          title: Text(user.displayName),
          subtitle: Text(
            user.email,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(user: user),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
        );
      },
    );
  }

  Widget showUsers() {
    return FutureBuilder(
      future: fetchUsers,
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return userList(snapshot.data);
          }
          return Center(
            child: Text(
              'No Users available !!!',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Chat'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: AuthService.user,
          builder: (
            context,
            AsyncSnapshot<FirebaseUser> snapshot,
          ) {
            if (snapshot.hasData) {
              return showUsers();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error),
              );
            }
            return Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Login to continue ...',
                    ),
                    SizedBox(height: 10),
                    GoogleButton().googleButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
