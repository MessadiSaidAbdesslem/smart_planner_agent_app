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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaXZpwl9TjYKAk7IJsQ9Ndz38PUEQRFWI',
    appId: '1:346386381295:android:8b5df1e0b15c395f39de1a',
    messagingSenderId: '346386381295',
    projectId: 'smartplaner-b98ed',
    databaseURL: 'https://smartplaner-b98ed-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'smartplaner-b98ed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBt9QfXkT_eKBpSkWXmejcOdeKvMRlM60',
    appId: '1:346386381295:ios:e032fc442007f90e39de1a',
    messagingSenderId: '346386381295',
    projectId: 'smartplaner-b98ed',
    databaseURL: 'https://smartplaner-b98ed-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'smartplaner-b98ed.appspot.com',
    iosClientId: '346386381295-q1svon0ariagpm4fcril16fj0kq3rv9h.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartPlannerAgentApp',
  );
}
