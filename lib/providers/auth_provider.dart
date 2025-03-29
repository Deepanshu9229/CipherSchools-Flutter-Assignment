import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  AuthProvider() {
    _checkSignIn();
  }

  bool get isAuthenticated => user != null;

  Future<void> _checkSignIn() async {
    user = _auth.currentUser;
    // Optionally retrieve additional info from SharedPreferences if needed.
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
  try {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    print('Google user selected: $googleUser');
    
    if (googleUser == null) {
      print('User aborted the Google sign-in process.');
      return;
    }
    
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print('Google auth details: accessToken=${googleAuth.accessToken}, idToken=${googleAuth.idToken}');
    
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    // Sign in to Firebase with the credential
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    user = userCredential.user;
    print('Firebase sign-in successful. User: ${user?.displayName}');
    
    // Save or update user info in Cloud Firestore
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    await userDoc.set({
      'name': user!.displayName,
      'email': user!.email,
    }, SetOptions(merge: true));
    print('User info saved to Firestore.');
    
    // Store user id locally for persistent login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user!.uid);
    print('User ID stored in local storage.');
    
    // Notify listeners to rebuild UI based on auth state
    notifyListeners();
    
  } catch (e) {
    print('Error during Google sign-in: $e');
  }
}


  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    user = null;
    notifyListeners();
  }
}
