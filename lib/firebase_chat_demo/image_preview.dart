import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/firebase_chat_demo/message.modal.dart';

import 'chat.service.dart';

class ImagePreview extends StatefulWidget {
  final Message message;
  final File image;

  const ImagePreview({
    Key key,
    @required this.message,
    @required this.image,
  }) : super(key: key);
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  onSend() {
    FirebaseChat.sendMessageWithImage(widget.message, widget.image);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        actions: <Widget>[
          FlatButton(
            onPressed: onSend,
            child: Text('SEND'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Image(
            image: FileImage(widget.image),
          ),
        ),
      ),
    );
  }
}
