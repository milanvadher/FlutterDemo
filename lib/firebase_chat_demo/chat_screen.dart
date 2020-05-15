import 'package:flutter/material.dart';
import 'package:flutter_demo/google_login/user.model.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({Key key, @required this.user}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget buidTitle() {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_back),
            SizedBox(
              width: 5,
            ),
            Container(
              padding: EdgeInsets.only(right: 10),
              child: Hero(
                tag: widget.user.uid,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(widget.user.photoUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[buidTitle(), Text(widget.user.displayName)],
        ),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
