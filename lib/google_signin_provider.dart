import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      UserCredential authResult = await _auth.signInWithCredential(credential);
      // User? user = authResult.user;
      // FirebaseFirestore firestore = FirebaseFirestore.instance;
      // await firestore.collection('users').doc(user!.uid).set({
      //   'uid': user.uid,
      //   'displayName': user.displayName,
      //   'email': user.email,
      //   // Add more fields as needed
      // });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  googleSigOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
  }
}
