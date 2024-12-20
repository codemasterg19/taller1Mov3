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
    apiKey: 'AIzaSyDOciLIXljsEPbLysGSAxjaFA72Q6CMQEI',
    appId: '1:263626630431:web:50b36088e907ba1d077c2a',
    messagingSenderId: '263626630431',
    projectId: 'juegomoviles-a6162',
    authDomain: 'juegomoviles-a6162.firebaseapp.com',
    databaseURL: 'https://juegomoviles-a6162-default-rtdb.firebaseio.com',
    storageBucket: 'juegomoviles-a6162.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsxvkiFAZ-HTxtsj8DWWpXOKD4UvR9wDY',
    appId: '1:263626630431:android:aa8d498432e0e9a4077c2a',
    messagingSenderId: '263626630431',
    projectId: 'juegomoviles-a6162',
    databaseURL: 'https://juegomoviles-a6162-default-rtdb.firebaseio.com',
    storageBucket: 'juegomoviles-a6162.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDOciLIXljsEPbLysGSAxjaFA72Q6CMQEI',
    appId: '1:263626630431:web:74c8b5c9746d08a5077c2a',
    messagingSenderId: '263626630431',
    projectId: 'juegomoviles-a6162',
    authDomain: 'juegomoviles-a6162.firebaseapp.com',
    databaseURL: 'https://juegomoviles-a6162-default-rtdb.firebaseio.com',
    storageBucket: 'juegomoviles-a6162.appspot.com',
  );
}
