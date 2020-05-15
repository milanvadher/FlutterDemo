import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo/firebase_demo/firestore.service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  // Dependencies
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  static final Firestore _db = Firestore.instance;

  static final user = BehaviorSubject<FirebaseUser>();

  static Future<void> checkUserLoginStatus() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    user.sink.add(firebaseUser);
  }

  static Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(authCredential);

      FirebaseUser firebaseUser = authResult.user;

      await _db
          .collection(FirestoreService.userTableName)
          .document(firebaseUser.uid)
          .setData({
        "uid": firebaseUser.uid,
        "displayName": firebaseUser.displayName,
        "email": firebaseUser.email,
        "phoneNumber": firebaseUser.phoneNumber,
        "photoUrl": firebaseUser.photoUrl,
        "isEmailVerified": firebaseUser.isEmailVerified,
      });

      user.sink.add(firebaseUser);
    } catch (e) {
      print('Error to Login');
      print(e);
      user.sink.addError(e);
    }
  }

  static void signOutGoogle() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    user.sink.add(null);
    user.drain();
  }
}
