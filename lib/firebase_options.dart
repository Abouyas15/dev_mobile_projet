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
    apiKey: 'AIzaSyC7ntHO3LenehFEexK02ydqddoUFG_OnBw',
    appId: '1:200838064107:web:da7df49786ca4049ee5bae',
    messagingSenderId: '200838064107',
    projectId: 'ibamedt-4bcb6',
    authDomain: 'ibamedt-4bcb6.firebaseapp.com',
    storageBucket: 'ibamedt-4bcb6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCERWiNVgKtZupyw7dEPr5T1wjOyeIYuyM',
    appId: '1:200838064107:android:a6e43896897448c8ee5bae',
    messagingSenderId: '200838064107',
    projectId: 'ibamedt-4bcb6',
    storageBucket: 'ibamedt-4bcb6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFUv6DnqMxnIDRJPMm0_RX58t9s_2rmog',
    appId: '1:200838064107:ios:04fca87f95d1635dee5bae',
    messagingSenderId: '200838064107',
    projectId: 'ibamedt-4bcb6',
    storageBucket: 'ibamedt-4bcb6.firebasestorage.app',
    iosBundleId: 'com.example.ibamedt',
  );

}