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
    apiKey: 'AIzaSyDiQZFAlkleG-MyIRiV_yD1HkEekJj39SM',
    appId: '1:1691011741:web:602e81fcc17bcbde1f2274',
    messagingSenderId: '1691011741',
    projectId: 'learn-82d06',
    authDomain: 'learn-82d06.firebaseapp.com',
    storageBucket: 'learn-82d06.firebasestorage.app',
    measurementId: 'G-ZPCFM3EBHM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByAN1_I36f8FImJv_w-yVxn2C1zhVHJJk',
    appId: '1:1691011741:android:8e46c0f989bfe2211f2274',
    messagingSenderId: '1691011741',
    projectId: 'learn-82d06',
    storageBucket: 'learn-82d06.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDD7o5vBmETrGcmYDvYl0_uQCnbManySmc',
    appId: '1:1691011741:ios:5123035c995ba05c1f2274',
    messagingSenderId: '1691011741',
    projectId: 'learn-82d06',
    storageBucket: 'learn-82d06.firebasestorage.app',
    iosClientId: '1691011741-4mk3o4c0gvk8kdrq25d7lrun9pa4q0or.apps.googleusercontent.com',
    iosBundleId: 'com.example.learn',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDD7o5vBmETrGcmYDvYl0_uQCnbManySmc',
    appId: '1:1691011741:ios:5123035c995ba05c1f2274',
    messagingSenderId: '1691011741',
    projectId: 'learn-82d06',
    storageBucket: 'learn-82d06.firebasestorage.app',
    iosClientId: '1691011741-4mk3o4c0gvk8kdrq25d7lrun9pa4q0or.apps.googleusercontent.com',
    iosBundleId: 'com.example.learn',
  );
}
