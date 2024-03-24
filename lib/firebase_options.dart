// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAEkM2KX4Ut_cea3F6DonGRmPST-h8FQfM',
    appId: '1:899347822117:web:8f9078e5c3ff1ac50eb1cc',
    messagingSenderId: '899347822117',
    projectId: 'myshop-bcdef',
    authDomain: 'myshop-bcdef.firebaseapp.com',
    storageBucket: 'myshop-bcdef.appspot.com',
    measurementId: 'G-7QBV1R4209',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZbMDLSG8mvEHiANerGox0EuYBQtHSGVA',
    appId: '1:899347822117:android:67c3da808f7b38c20eb1cc',
    messagingSenderId: '899347822117',
    projectId: 'myshop-bcdef',
    storageBucket: 'myshop-bcdef.appspot.com',
  );
}
