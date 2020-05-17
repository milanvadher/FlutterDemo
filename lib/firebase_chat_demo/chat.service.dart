import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'message.modal.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore

class FirebaseChat {
  static String messageTableName = 'chats';
  static String columnSenderUid = 'senderUid';
  static String columnReceiverUid = 'receiverUid';
  static String columnSenderMessage = 'senderMessage';
  static String columnPhotoUrl = 'photoUrl';
  static String columnTimestamp = 'lastLogin';
  static String columnChat = 'chat';
  static String columnChatId = 'chatId';

  static final Firestore firestore = Firestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static String conversationId;

  static final getUserRef =
      firestore.collection(AuthService.userTableName).snapshots();

  static Stream<QuerySnapshot> getMessages() {
    return firestore
        .collection(messageTableName)
        .document(conversationId)
        .collection(conversationId)
        .orderBy(FirebaseChat.columnTimestamp, descending: true)
        .limit(100)
        .snapshots();
  }

  static sendMessage(Message message) async {
    await firestore
        .collection(messageTableName)
        .document(conversationId)
        .collection(conversationId)
        .add(message.toMap());
  }

  static sendMessageWithImage(Message message, File image) async {
    StorageReference storageReference = storage.ref().child(
          'image_${DateTime.now().millisecondsSinceEpoch}',
        );
    StorageUploadTask storageUploadTask = storageReference.putFile(image);
    await storageUploadTask.onComplete;
    message.photoUrl = await storageReference.getDownloadURL();
    sendMessage(message);
  }

  static String setOneToOneChat(String senderUid, String receiverUid) {
    if (senderUid.hashCode <= receiverUid.hashCode) {
      return senderUid + receiverUid;
    }
    return receiverUid + senderUid;
  }
}
