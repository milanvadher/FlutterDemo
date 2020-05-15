import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/google_login/user.model.dart';

class FirebaseChat {
  static final Firestore _db = Firestore.instance;

  static Future<List<User>> getUsers() async {
    QuerySnapshot qs =
        await _db.collection(AuthService.userTableName).getDocuments();

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
}
