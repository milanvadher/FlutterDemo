import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/google_login/auth.service.dart';

class User {
  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final bool isEmailVerified;

  User({
    this.uid,
    @required this.displayName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.isEmailVerified,
  }) : assert(displayName != null);

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      AuthService.columnUid: uid,
      AuthService.columnDisplayName: displayName,
      AuthService.columnEmail: email,
      AuthService.columnPhoneNumber: phoneNumber,
      AuthService.columnPhotoUrl: photoUrl,
      AuthService.columnIsEmailVerified: isEmailVerified,
    };
  }

  static User toJson(DocumentSnapshot documentSnapshot) {
    return User(
      uid: documentSnapshot.data[AuthService.columnUid],
      displayName: documentSnapshot.data[AuthService.columnDisplayName],
      email: documentSnapshot.data[AuthService.columnEmail],
      phoneNumber: documentSnapshot.data[AuthService.columnPhoneNumber],
      photoUrl: documentSnapshot.data[AuthService.columnPhotoUrl],
      isEmailVerified: documentSnapshot.data[AuthService.columnIsEmailVerified],
    );
  }
}
