import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/Pages/namePage.dart';

class AuthService {
  //Handles Auth
  handleAuth(AppState appState) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return HomeBuilder(appState);
          } else {
            return NamePage(appState);
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
      },
    );
  }

  //Sign out
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) async {
    AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(authCreds);
    return authResult;
  }

  signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    return await signIn(authCreds);
  }

  isSignedIn() async {
    return await FirebaseAuth.instance.currentUser() != null;
  }
}
