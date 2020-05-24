import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/firebase_chat_demo/image_preview.dart';
import 'package:flutter_demo/firebase_chat_demo/message.modal.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/google_login/user.model.dart';
import 'package:flutter_demo/settings.bloc.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'chat.service.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({Key key, @required this.user}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  BehaviorSubject<bool> _isComposing = new BehaviorSubject();
  final bool isDarkTheme = SettingsBloc.isDarkTheme.value ?? false;

  _onTextMsgSubmitted(String text) async {
    print(text);
    if (text.isNotEmpty) {
      _textController.clear();
      _isComposing.sink.add(false);
      Message message = Message(
        senderUid: AuthService.user.value.uid,
        receiverUid: widget.user.uid,
        senderMessage: text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      await FirebaseChat.sendMessage(message);
    }
  }

  Future chooseImage({bool isCamera = false}) async {
    File image = await ImagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 600,
      imageQuality: 50,
    );
    if (image != null) {
      Message message = Message(
        senderUid: AuthService.user.value.uid,
        receiverUid: widget.user.uid,
        senderMessage: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreview(message: message, image: image),
          fullscreenDialog: true,
        ),
      );
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
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      width: double.infinity,
      height: 50.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  chooseImage(isCamera: true);
                },
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(Icons.add_photo_alternate),
                onPressed: chooseImage,
              ),
            ),
          ),
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
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                ),
                onChanged: (String text) {
                  _isComposing.sink.add(text.length > 0);
                },
                onSubmitted: _onTextMsgSubmitted,
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: StreamBuilder(
                stream: _isComposing,
                initialData: false,
                builder: (context, snapshot) {
                  return IconButton(
                    icon: Icon(Icons.send),
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

  errorImageWidget({bool isDisplayMsg = true}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.error, color: Colors.redAccent, size: 30),
        if (isDisplayMsg)
          SizedBox(
            height: 10,
          ),
        if (isDisplayMsg) Text('Failed to load Image'),
      ],
    );
  }

  previewImage(Message message) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SafeArea(
          child: Container(
            child: Center(
              child: Hero(
                tag: message.timestamp,
                child: CachedNetworkImage(
                  imageUrl: message.photoUrl,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: errorImageWidget(isDisplayMsg: false),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget timeStamp(Message message) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Text(
        '${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(message.timestamp))}',
        style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10),
      ),
    );
  }

  Widget imageMessage(Message message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () {
            previewImage(message);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Hero(
              tag: message.timestamp,
              child: CachedNetworkImage(
                width: 250,
                height: 250,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                imageUrl: message.photoUrl,
                placeholder: (context, url) => Container(
                  width: 250,
                  height: 250,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 250,
                  height: 250,
                  child: Center(
                    child: errorImageWidget(),
                  ),
                ),
              ),
            ),
          ),
        ),
        timeStamp(message),
      ],
    );
  }

  Widget textMessage(Message message) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      alignment: WrapAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(message.senderMessage),
        ),
        timeStamp(message),
      ],
    );
  }

  Widget messageBubble(QuerySnapshot querySnapshot, int index) {
    Message message = Message.toJson(
      querySnapshot.documents[index],
    );
    bool isSendByMe = message.senderUid == AuthService.user.value.uid;
    return Container(
      margin: EdgeInsets.only(
        left: isSendByMe ? 60 : 10,
        right: isSendByMe ? 10 : 60,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        alignment: isSendByMe ? WrapAlignment.end : WrapAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment:
                isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(vertical: 3),
                color: isSendByMe
                    ? isDarkTheme
                        ? Colors.deepPurple.shade700
                        : Colors.deepPurple.shade200
                    : null,
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: message.photoUrl != null
                      ? imageMessage(message)
                      : textMessage(message),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget conversationUI() {
    return StreamBuilder(
      stream: FirebaseChat.getMessages(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, int index) {
              return messageBubble(snapshot.data, index);
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
    return SizedBox.expand(
      child: Image(
        fit: BoxFit.cover,
        image: AssetImage(
          isDarkTheme ? 'assets/dark_bg.png' : 'assets/light_bg.png',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseChat.conversationId = FirebaseChat.setOneToOneChat(
      AuthService.user.value.uid,
      widget.user.uid,
    );
    _isComposing.sink.add(false);
  }

  @override
  void dispose() {
    super.dispose();
    FirebaseChat.conversationId = null;
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
        child: Stack(
          children: <Widget>[
            backgroundImage(),
            Column(
              children: <Widget>[
                Expanded(
                  child: conversationUI(),
                ),
                composeMsg(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
