import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkUserStatus();
  }

  // Checking the current authentication status using SharedPreferences.
  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userId');
    if (storedUserId != null) {
      _user = _auth.currentUser;
      _isAuthenticated = _user != null;
    } else {
      _user = null;
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  //Sign Up with Google
  Future<void> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("User canceled Google Sign-Up");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      _isAuthenticated = _user != null;
      notifyListeners();

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // saving info in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .set({
          'name': _user!.displayName,
          'email': _user!.email,
        }, SetOptions(merge: true));
        print("New user signed up: ${_user?.displayName}");
      } else {
        print("Existing user signing up, treating as login: ${_user?.displayName}");
      }

     // for remain login 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.uid);
      print("User ID stored in local storage.");

    } catch (e) {
      print("Error signing up with Google: $e");
    }
  }

  //Sign In with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("User canceled Google Sign-In");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      _isAuthenticated = _user != null;
      notifyListeners();

      // Updateing  Firestore 
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .set({
        'name': _user!.displayName,
        'email': _user!.email,
      }, SetOptions(merge: true));
      print("User signed in: ${_user?.displayName}");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.uid);
      print("User ID stored in local storage.");
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  //Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
