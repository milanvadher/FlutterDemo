import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
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

  static String conversationId;

  static final getUserRef =
      _db.collection(AuthService.userTableName).snapshots();

  static Stream<QuerySnapshot> getMessages() {
    return _db
        .collection(messageTableName)
        .document(conversationId)
        .collection(conversationId)
        .orderBy(FirebaseChat.columnTimestamp, descending: true)
        .limit(100)
        .snapshots();
  }

  static sendMessage(Message message) async {
    await _db
        .collection(messageTableName)
        .document(conversationId)
        .collection(conversationId)
        .add(message.toMap());
  }

  static String setOneToOneChat(String senderUid, String receiverUid) {
    if ((senderUid.codeUnits).reduce((a, b) => a + b) <
        (receiverUid.codeUnits).reduce((a, b) => a + b)) {
      return senderUid + receiverUid;
    }
    return receiverUid + senderUid;
  }
}
