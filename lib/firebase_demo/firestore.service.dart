import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo/firebase_demo/NoteFirebase.dart';
import 'package:flutter_demo/firebase_demo/auth.service.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  static final Firestore _db = Firestore.instance;

  static createNote(NoteFirebase note) async {
    FirebaseUser firebaseUser = AuthService.user.value;

    String now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    note.createdAt = now;
    note.updatedAt = now;

    await _db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('notes')
        .add(
          note.toMap(),
        );
  }

  static updateNote(NoteFirebase note) async {
    FirebaseUser firebaseUser = AuthService.user.value;

    String now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    note.updatedAt = now;

    await _db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('notes')
        .document(note.firebasseId)
        .setData(
          note.toMap(),
        );
  }

  static deleteNote(String noteId) async {
    FirebaseUser firebaseUser = AuthService.user.value;

    await _db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('notes')
        .document(noteId)
        .delete();
  }

  static Future<List<NoteFirebase>> getNotes() async {
    FirebaseUser firebaseUser = AuthService.user.value;
    QuerySnapshot qs = await _db
        .collection('users')
        .document(firebaseUser.uid)
        .collection('notes')
        .getDocuments();

    return List.generate(qs.documents.toList().length, (i) {
      return NoteFirebase(
        firebasseId: qs.documents.toList()[i].documentID,
        title: qs.documents.toList()[i].data['title'],
        discription: qs.documents.toList()[i].data['discription'],
        createdAt: qs.documents.toList()[i].data['createdAt'],
        updatedAt: qs.documents.toList()[i].data['updatedAt'],
      );
    }).toList();
  }
}
