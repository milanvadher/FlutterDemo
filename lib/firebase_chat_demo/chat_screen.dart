import 'dart:math';

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
      padding: EdgeInsets.only(right: 10),
      child: Hero(
        tag: widget.user.uid,
        child: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(widget.user.photoUrl),
        ),
      ),
    );
  }

  Widget draftArea() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: 'Type a message',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.tag_faces),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: CircleAvatar(
              radius: 25,
              child: FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget conversationUI() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, int index) {
        return Row(
          mainAxisAlignment: Random().nextInt(2) == 1
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Text('Hey, How are you ?'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buidTitle(),
            Text(widget.user.displayName),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: conversationUI(),
            ),
            draftArea(),
          ],
        ),
      ),
    );
  }
}
