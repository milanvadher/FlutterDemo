import 'package:flutter/foundation.dart';
import 'package:flutter_demo/firebase_demo/firestore.service.dart';

class NoteFirebase {
  final String firebasseId;
  final String title;
  final String discription;
  String createdAt;
  String updatedAt;

  NoteFirebase({
    this.firebasseId,
    @required this.title,
    this.discription,
    this.createdAt,
    this.updatedAt,
  }) : assert(title != null);

  // Convert a NoteFirebase into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      FirestoreService.columnId: firebasseId,
      FirestoreService.columnTitle: title,
      FirestoreService.columnDiscription: discription,
      FirestoreService.columnCreatedAt: createdAt,
      FirestoreService.columnUpdatedAt: updatedAt,
    };
  }
}
