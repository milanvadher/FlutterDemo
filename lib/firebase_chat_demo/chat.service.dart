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

  // Firesore instance
  static final Firestore firestore = Firestore.instance;
  // Firebase storage instance
  static final FirebaseStorage storage = FirebaseStorage.instance;

  // uniq conversation id between 2 users
  static String conversationId;

  /// Users stream
  /// Get all users from firestore [user] collection
  static final getUserRef = firestore
      .collection(
        AuthService.userTableName,
      )
      .snapshots();

  /// message stream
  /// Get last 100 message from firestore from [chat] collection
  static Stream<QuerySnapshot> getMessages() {
    return firestore
        .collection(messageTableName)
        .document(conversationId)
        .collection(conversationId)
        .orderBy(FirebaseChat.columnTimestamp, descending: true)
        .limit(100)
        .snapshots();
  }

  /// save [message] into chat collection
  /// using uniq [conversationId]
  static sendMessage(Message message) async {
    await firestore
        .collection(messageTableName)
        .document(conversationId)
        .collection(conversationId)
        .add(message.toMap());
  }

  /// Send Message with image
  /// [message] - Message
  /// [image] - File
  static sendMessageWithImage(Message message, File image) async {
    StorageReference storageReference = storage.ref().child(
          'image_${DateTime.now().millisecondsSinceEpoch}',
        );
    StorageUploadTask storageUploadTask = storageReference.putFile(image);
    await storageUploadTask.onComplete;
    message.photoUrl = await storageReference.getDownloadURL();
    sendMessage(message);
  }

  /// Create uniq [conversationId] based on uid of 2 users
  static String setOneToOneChat(String senderUid, String receiverUid) {
    if (senderUid.hashCode <= receiverUid.hashCode) {
      return senderUid + receiverUid;
    }
    return receiverUid + senderUid;
  }
}
