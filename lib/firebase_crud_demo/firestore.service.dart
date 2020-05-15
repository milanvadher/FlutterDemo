import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'NoteFirebase.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  static final Firestore _db = Firestore.instance;
  static String noteTableName = 'notes';
  static String columnId = 'firebaseId';
  static String columnTitle = 'title';
  static String columnDiscription = 'discription';
  static String columnCreatedAt = 'createdAt';
  static String columnUpdatedAt = 'updatedAt';

  static createNote(NoteFirebase note) async {
    FirebaseUser firebaseUser = AuthService.user.value;

    String now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    note.createdAt = now;
    note.updatedAt = now;

    await _db
        .collection(noteTableName)
        .document(firebaseUser.uid)
        .collection(noteTableName)
        .add(
          note.toMap(),
        );
  }

  static updateNote(NoteFirebase note) async {
    FirebaseUser firebaseUser = AuthService.user.value;

    String now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    note.updatedAt = now;

    await _db
        .collection(noteTableName)
        .document(firebaseUser.uid)
        .collection(noteTableName)
        .document(note.firebasseId)
        .setData(
          note.toMap(),
        );
  }

  static deleteNote(String noteId) async {
    FirebaseUser firebaseUser = AuthService.user.value;

    await _db
        .collection(noteTableName)
        .document(firebaseUser.uid)
        .collection(noteTableName)
        .document(noteId)
        .delete();
  }

  static Future<List<NoteFirebase>> getNotes() async {
    FirebaseUser firebaseUser = AuthService.user.value;
    QuerySnapshot qs = await _db
        .collection(noteTableName)
        .document(firebaseUser.uid)
        .collection(noteTableName)
        .orderBy(columnUpdatedAt, descending: true)
        .getDocuments();

    return List.generate(qs.documents.length, (i) {
      DocumentSnapshot documentSnapshot = qs.documents[i];
      return NoteFirebase(
        firebasseId: documentSnapshot.documentID,
        title: documentSnapshot.data[columnTitle],
        discription: documentSnapshot.data[columnDiscription],
        createdAt: documentSnapshot.data[columnCreatedAt],
        updatedAt: documentSnapshot.data[columnUpdatedAt],
      );
    }).toList();
  }
}
