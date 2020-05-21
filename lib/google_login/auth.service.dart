import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo/notification/firebase_notification.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  static String userTableName = 'users';
  static String columnUid = 'uid';
  static String columnDisplayName = 'displayName';
  static String columnEmail = 'email';
  static String columnPhoneNumber = 'phoneNumber';
  static String columnPhotoUrl = 'photoUrl';
  static String columnIsEmailVerified = 'isEmailVerified';
  static String columnTimestamp = 'timestamp';

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
          .collection(AuthService.userTableName)
          .document(firebaseUser.uid)
          .setData({
        columnUid: firebaseUser.uid,
        columnDisplayName: firebaseUser.displayName,
        columnEmail: firebaseUser.email,
        columnPhoneNumber: firebaseUser.phoneNumber,
        columnPhotoUrl: firebaseUser.photoUrl,
        columnIsEmailVerified: firebaseUser.isEmailVerified,
        columnTimestamp: DateTime.now().millisecondsSinceEpoch,
      });

      user.sink.add(firebaseUser);

      await FirebaseNotification.setup();
    } catch (e) {
      print('Error to Login');
      print(e);
      user.sink.addError(e);
    }
  }

  static void signOutGoogle() async {
    await _auth.signOut();
    await FirebaseNotification.unRegister();
    await googleSignIn.signOut();
    user.sink.add(null);
    user.drain();
  }
}
