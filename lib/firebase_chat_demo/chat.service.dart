import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/google_login/user.model.dart';
import 'message.modal.dart';

class FirebaseChat {
  static String messageTableName = 'chats';
  static String columnSenderUid = 'senderUid';
  static String columnReceiverUid = 'receiverUid';
  static String columnSenderMessage = 'senderMessage';
  static String columnTimestamp = 'lastLogin';
  static String columnChat = 'chat';
  static String columnChatId = 'chatId';

  static final Firestore _db = Firestore.instance;

  static final getUserRef =
      _db.collection(AuthService.userTableName).snapshots();

  static Stream<QuerySnapshot> getMessages(User receiver) {
    return _db
        .collection(messageTableName)
        .document(setOneToOneChat(AuthService.user.value.uid, receiver.uid))
        .collection(setOneToOneChat(AuthService.user.value.uid, receiver.uid))
        .orderBy(FirebaseChat.columnTimestamp, descending: true)
        .limit(100)
        .snapshots();
  }

  static sendMessage(Message message) async {
    await _db
        .collection(messageTableName)
        .document(setOneToOneChat(message.senderUid, message.receiverUid))
        .collection(setOneToOneChat(message.senderUid, message.receiverUid))
        .add(message.toMap());
  }

  static String setOneToOneChat(String senderUid, String receiverUid) {
    if (senderUid.codeUnitAt(0) < receiverUid.codeUnitAt(0)) {
      return senderUid + receiverUid;
    }
    return receiverUid + senderUid;
  }
}
