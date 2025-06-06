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
    apiKey: 'AIzaSyAXEtFEIOwAwdi60fEy_NwkuB69V4hHjD0',
    appId: '1:613482172357:web:fc403ca8c43f6bfa2b85ac',
    messagingSenderId: '613482172357',
    projectId: 'renuoil-d9855',
    authDomain: 'renuoil-d9855.firebaseapp.com',
    storageBucket: 'renuoil-d9855.firebasestorage.app',
    measurementId: 'G-D5QC4Y7G5L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChMyuEp31B4haFsN4zXdaIgzOIvxn6QI8',
    appId: '1:613482172357:android:0f2be1c6e09e0ed62b85ac',
    messagingSenderId: '613482172357',
    projectId: 'renuoil-d9855',
    storageBucket: 'renuoil-d9855.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6KC5QyXJxEkGeZGGg0NFsc45K5ojHTEk',
    appId: '1:613482172357:ios:17e36e8f227bb4182b85ac',
    messagingSenderId: '613482172357',
    projectId: 'renuoil-d9855',
    storageBucket: 'renuoil-d9855.firebasestorage.app',
    iosBundleId: 'com.example.uasRenuoil',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6KC5QyXJxEkGeZGGg0NFsc45K5ojHTEk',
    appId: '1:613482172357:ios:17e36e8f227bb4182b85ac',
    messagingSenderId: '613482172357',
    projectId: 'renuoil-d9855',
    storageBucket: 'renuoil-d9855.firebasestorage.app',
    iosBundleId: 'com.example.uasRenuoil',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAXEtFEIOwAwdi60fEy_NwkuB69V4hHjD0',
    appId: '1:613482172357:web:301e46eff4be76d52b85ac',
    messagingSenderId: '613482172357',
    projectId: 'renuoil-d9855',
    authDomain: 'renuoil-d9855.firebaseapp.com',
    storageBucket: 'renuoil-d9855.firebasestorage.app',
    measurementId: 'G-5Q9468R02N',
  );
}
