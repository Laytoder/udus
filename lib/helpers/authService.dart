import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/phoneNumPage.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/helpers/nearbyVendorQueryHelper.dart';

class AuthService {

  //Handles Auth
  handleAuth(AppState appState) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(appState);
          } else {
            return PhoneNumPage(appState);
          }
        });
  }

  //Sign out
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) async {
    await FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCreds);
  }
}
