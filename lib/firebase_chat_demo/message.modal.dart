import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'chat.service.dart';

class Message {
  final String senderUid;
  final String receiverUid;
  final String senderMessage;
  String photoUrl;
  final int timestamp;

  Message({
    @required this.senderUid,
    @required this.receiverUid,
    @required this.senderMessage,
    this.photoUrl,
    @required this.timestamp,
  })  : assert(senderUid != null),
        assert(receiverUid != null),
        assert(senderMessage != null),
        assert(timestamp != null);

  // Convert a Message into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      FirebaseChat.columnSenderUid: senderUid,
      FirebaseChat.columnReceiverUid: receiverUid,
      FirebaseChat.columnSenderMessage: senderMessage,
      FirebaseChat.columnPhotoUrl: photoUrl,
      FirebaseChat.columnTimestamp: timestamp,
    };
  }

  static Message toJson(DocumentSnapshot documentSnapshot) {
    return Message(
      senderUid: documentSnapshot.data[FirebaseChat.columnSenderUid],
      receiverUid: documentSnapshot.data[FirebaseChat.columnReceiverUid],
      senderMessage: documentSnapshot.data[FirebaseChat.columnSenderMessage],
      photoUrl: documentSnapshot.data[FirebaseChat.columnPhotoUrl],
      timestamp: documentSnapshot.data[FirebaseChat.columnTimestamp],
    );
  }
}
