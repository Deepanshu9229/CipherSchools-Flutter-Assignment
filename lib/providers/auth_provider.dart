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
    // Listen to Firebase auth state changes for automatic updates.
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      _isAuthenticated = _user != null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_isAuthenticated && _user != null) {
        await prefs.setString('userId', _user!.uid);
      } else {
        await prefs.remove('userId');
      }
      notifyListeners();
    });
  }

  /// Sign In with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("User canceled Google Sign-In");
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      _isAuthenticated = _user != null;
      notifyListeners();

      if (_user != null) {
        // Update or set user info in Firestore (merge with existing data if any)
        await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
          'name': _user!.displayName,
          'email': _user!.email,
        }, SetOptions(merge: true));
        print("User signed in: ${_user?.displayName}");
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  /// Sign Up with Google
  Future<void> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("User canceled Google Sign-Up");
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      _isAuthenticated = _user != null;
      notifyListeners();

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // If it's a new user, save their info in Firestore.
        await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
          'name': _user!.displayName,
          'email': _user!.email,
        }, SetOptions(merge: true));
        print("New user signed up: ${_user?.displayName}");
      } else {
        print("Existing user signing up, treating as login: ${_user?.displayName}");
      }

      // Store user id locally for persistent login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.uid);
      print("User ID stored in local storage.");
    } catch (e) {
      print("Error signing up with Google: $e");
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.disconnect();
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
