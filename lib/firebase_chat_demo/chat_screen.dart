import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/firebase_chat_demo/message.modal.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/google_login/user.model.dart';
import 'package:flutter_demo/settings.bloc.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';

import 'chat.service.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({Key key, @required this.user}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  BehaviorSubject<bool> _isComposing = new BehaviorSubject();

  _onTextMsgSubmitted(String text) async {
    print(text);
    if (text.isNotEmpty) {
      _textController.clear();
      Message message = Message(
        senderUid: AuthService.user.value.uid,
        receiverUid: widget.user.uid,
        senderMessage: text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      await FirebaseChat.sendMessage(message);
    }
  }

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

  Widget composeMsg() {
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
              child: TextField(
                controller: _textController,
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
                onChanged: (String text) {
                  _isComposing.sink.add(text.length > 0);
                },
                onSubmitted: _onTextMsgSubmitted,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: CircleAvatar(
              radius: 25,
              child: StreamBuilder(
                stream: _isComposing,
                initialData: false,
                builder: (context, snapshot) {
                  return FloatingActionButton(
                    child: Icon(Icons.send),
                    onPressed: snapshot.data
                        ? () => _onTextMsgSubmitted(_textController.text)
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget conversationUI() {
    return StreamBuilder(
      stream: FirebaseChat.getMsgRef,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int index) {
              Message message = Message.toJson(
                snapshot.data.documents[index],
              );
              bool isSendByMe = message.senderUid == AuthService.user.value.uid;
              return Container(
                margin: EdgeInsets.only(
                  left: isSendByMe ? 60 : 10,
                  bottom: 2,
                  right: isSendByMe ? 10 : 60,
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment:
                      isSendByMe ? WrapAlignment.end : WrapAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(message.senderMessage),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                '${DateFormat('KK:mm aa').format(DateTime.fromMillisecondsSinceEpoch(message.timestamp))}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget backgroundImage() {
    bool isDarkTheme = SettingsBloc.isDarkTheme.value ?? false;
    return SizedBox.expand(
      child: Opacity(
        opacity: isDarkTheme ? 0.2 : 1,
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage(
            isDarkTheme ? 'assets/dark_bg.png' : 'assets/light_bg.png',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isComposing.sink.add(false);
  }

  @override
  void dispose() {
    super.dispose();
    _isComposing.close();
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
              child: Stack(
                children: <Widget>[
                  backgroundImage(),
                  conversationUI(),
                ],
              ),
            ),
            composeMsg(),
          ],
        ),
      ),
    );
  }
}
