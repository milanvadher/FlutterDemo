import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/google_login/user.model.dart';

import 'message.modal.dart';

class FirebaseChat {
  static String messageTableName = 'message';
  static String columnSenderUid = 'senderUid';
  static String columnReceiverUid = 'receiverUid';
  static String columnSenderMessage = 'senderMessage';
  static String columnTimestamp = 'timestamp';

  static final Firestore _db = Firestore.instance;

  static final getMsgRef = _db
      .collection(FirebaseChat.messageTableName)
      .orderBy(FirebaseChat.columnTimestamp, descending: true)
      .limit(50)
      .snapshots();

  static final getUserRef =
      _db.collection(AuthService.userTableName).snapshots();

  static Future<List<User>> getUsers() async {
    QuerySnapshot qs = await _db
        .collection(
          AuthService.userTableName,
        )
        .getDocuments();

    List<User> users = List.generate(qs.documents.length, (i) {
      DocumentSnapshot documentSnapshot = qs.documents[i];
      return User(
        uid: documentSnapshot.data[AuthService.columnUid],
        displayName: documentSnapshot.data[AuthService.columnDisplayName],
        email: documentSnapshot.data[AuthService.columnEmail],
        phoneNumber: documentSnapshot.data[AuthService.columnPhoneNumber],
        photoUrl: documentSnapshot.data[AuthService.columnPhotoUrl],
        isEmailVerified:
            documentSnapshot.data[AuthService.columnIsEmailVerified],
      );
    }).toList();

    users.removeAt(
      users.indexWhere((element) => element.uid == AuthService.user.value?.uid),
    );

    return users;
  }

  static Future<List<Message>> getMessages() async {
    QuerySnapshot qs = await _db
        .collection(messageTableName)
        .orderBy(
          FirebaseChat.columnTimestamp,
          descending: true,
        )
        .getDocuments();

    return List.generate(qs.documents.length, (i) {
      DocumentSnapshot documentSnapshot = qs.documents[i];
      return Message(
        senderUid: documentSnapshot.data[FirebaseChat.columnSenderUid],
        receiverUid: documentSnapshot.data[FirebaseChat.columnReceiverUid],
        senderMessage: documentSnapshot.data[FirebaseChat.columnSenderMessage],
        timestamp: documentSnapshot.data[FirebaseChat.columnTimestamp],
      );
    }).toList();
  }

  static sendMessage(Message message) async {
    await _db.collection(messageTableName).add(message.toMap());
  }
}
