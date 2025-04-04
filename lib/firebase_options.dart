// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZKL71uZxVKlyy1AlwiebrJRGfxozxTIg',
    appId: '1:110886268860:web:8d7e83c0751e50b36e05b9',
    messagingSenderId: '110886268860',
    projectId: 'expense-tracker-app-4e79e',
    authDomain: 'expense-tracker-app-4e79e.firebaseapp.com',
    storageBucket: 'expense-tracker-app-4e79e.firebasestorage.app',
    measurementId: 'G-HMFTCJLSZM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJ8uv9PBc1gCptjkUK69rmZytPnLf-gV0',
    appId: '1:110886268860:android:bafcee4b4aa1cf406e05b9',
    messagingSenderId: '110886268860',
    projectId: 'expense-tracker-app-4e79e',
    storageBucket: 'expense-tracker-app-4e79e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIKF8nAV7cB52n3cci50cisoWeM9CjbsI',
    appId: '1:110886268860:ios:da0ba9016db7a6276e05b9',
    messagingSenderId: '110886268860',
    projectId: 'expense-tracker-app-4e79e',
    storageBucket: 'expense-tracker-app-4e79e.firebasestorage.app',
    iosBundleId: 'com.example.expenseTrackerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIKF8nAV7cB52n3cci50cisoWeM9CjbsI',
    appId: '1:110886268860:ios:da0ba9016db7a6276e05b9',
    messagingSenderId: '110886268860',
    projectId: 'expense-tracker-app-4e79e',
    storageBucket: 'expense-tracker-app-4e79e.firebasestorage.app',
    iosBundleId: 'com.example.expenseTrackerApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAZKL71uZxVKlyy1AlwiebrJRGfxozxTIg',
    appId: '1:110886268860:web:6f6a434003c3ffd46e05b9',
    messagingSenderId: '110886268860',
    projectId: 'expense-tracker-app-4e79e',
    authDomain: 'expense-tracker-app-4e79e.firebaseapp.com',
    storageBucket: 'expense-tracker-app-4e79e.firebasestorage.app',
    measurementId: 'G-K94HH72LLC',
  );
}
