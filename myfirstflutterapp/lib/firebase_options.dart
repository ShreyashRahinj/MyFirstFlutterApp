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
    apiKey: 'AIzaSyDcGjQsPewd1rOlS-m4qXVxybfRPgXRtpU',
    appId: '1:118662170890:web:786923c336304c89acd2f3',
    messagingSenderId: '118662170890',
    projectId: 'ssr-myfirstflutterapp',
    authDomain: 'ssr-myfirstflutterapp.firebaseapp.com',
    storageBucket: 'ssr-myfirstflutterapp.appspot.com',
    measurementId: 'G-HEFDRQWEVD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDeLNVevYddrvRWl_B6PBh-IDfXYEltRq0',
    appId: '1:118662170890:android:6feec2350e5afe3eacd2f3',
    messagingSenderId: '118662170890',
    projectId: 'ssr-myfirstflutterapp',
    storageBucket: 'ssr-myfirstflutterapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANzqePQ1Z4DMBYfmSj2iRcLPRkYEKmBas',
    appId: '1:118662170890:ios:c73815f0002f48e2acd2f3',
    messagingSenderId: '118662170890',
    projectId: 'ssr-myfirstflutterapp',
    storageBucket: 'ssr-myfirstflutterapp.appspot.com',
    iosClientId: '118662170890-7vn6c34u56u4nmulcuefilekavvt65o0.apps.googleusercontent.com',
    iosBundleId: 'com.SSR48.myfirstflutterapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANzqePQ1Z4DMBYfmSj2iRcLPRkYEKmBas',
    appId: '1:118662170890:ios:c73815f0002f48e2acd2f3',
    messagingSenderId: '118662170890',
    projectId: 'ssr-myfirstflutterapp',
    storageBucket: 'ssr-myfirstflutterapp.appspot.com',
    iosClientId: '118662170890-7vn6c34u56u4nmulcuefilekavvt65o0.apps.googleusercontent.com',
    iosBundleId: 'com.SSR48.myfirstflutterapp',
  );
}