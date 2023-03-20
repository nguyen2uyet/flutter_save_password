import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthService extends GetxController {
  var _googleUser = GoogleSignIn(scopes: <String>["email"]);
  var googleUserAccount = Rx<GoogleSignInAccount?>(null);
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (FirebaseAuth.instance.currentUser != null) {
          return HomePage(
              title: FirebaseAuth.instance.currentUser!.email.toString());
        } else {
          return LoginPage();
        }
      },
    );
  }

  signInWithGoogle() async {
    googleUserAccount.value = await _googleUser.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUserAccount.value!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithGoogleWeb() async {
    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  signOut() async {
    await _googleUser.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
