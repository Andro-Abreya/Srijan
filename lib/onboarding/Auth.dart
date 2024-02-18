import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_meet_sdk/google_meet_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  Future<int> signInWithGoogle() async {
    int res = 1;
    try {
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: "966596442183-hqq32oj50l2rprnpmn7h9l7v3di5uq45.apps.googleusercontent.com",
     // serverClientId: serverClientId,
      scopes: <String>[
        cal.CalendarApi.calendarScope,
        cal.CalendarApi.calendarEventsScope,
      ],
      );
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();
      final GoogleSignInAuthentication? googleSignInAuth = await googleSignInAccount
          ?.authentication;

          if (googleSignInAccount != null) {
      final GoogleAPIClient httpClient =
          GoogleAPIClient(await googleSignInAccount.authHeaders);
      CalendarClient.calendar = cal.CalendarApi(httpClient);

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // try {
      //   final UserCredential userCredential =
      //       await _auth.signInWithCredential(credential);
      //   user = userCredential.user;
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'account-exists-with-different-credential') {
      //     customSnackBar(
      //         content:
      //             'The account already exists with a different credential');
      //   } else if (e.code == 'invalid-credential') {
      //     customSnackBar(
      //         content:
      //             'Error occurred while accessing credentials. Try again.');
      //   }
      // } catch (e) {
      //   customSnackBar(
      //       content: 'Error occurred using Google Sign In. Try again.');
      // }
    }

      final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth?.accessToken,
          idToken: googleSignInAuth?.idToken
      );

      UserCredential userCredential = await _auth
          .signInWithCredential(credential);

      //print("$userCredential");
      User? user = userCredential.user;
      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          res = 1;
          // await _firestore.collection('Users').doc(user.uid).set({
          //   'userName': user.displayName,
          // });
        }
        res = 2;
      }
    } catch (e) {
      print(e);
      res = 0;

    }
    return res;
  }

   static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
