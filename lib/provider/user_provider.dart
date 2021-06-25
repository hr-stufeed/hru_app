import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  User currentUser;
  String name = "";
  String email = "";
  String photoURL = "";
  bool isLoggedin = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void signIn(User user) {
    currentUser = user;
    photoURL = user.photoURL;
    name = user.displayName;
    email = user.email;
    isLoggedin = true;
  }

  Future<bool> signOut() async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      currentUser = null;
      photoURL = " ";
      name = " ";
      email = " ";
      isLoggedin = false;
      print("Success");
      return isLoggedin;
    } catch (e) {
      print(e.toString());
    }
  }

  String getPhotoURL() {
    return photoURL;
  }

  String getUserName() {
    return name;
  }

  bool getLoginState() {
    return isLoggedin;
  }
}
