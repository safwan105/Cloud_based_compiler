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
    apiKey: 'AIzaSyANcH3d_XbebfLdGtFEn4YNkwc2upFH4L0',
    appId: '1:402312114878:web:18d558c93497d0fb2124ef',
    messagingSenderId: '402312114878',
    projectId: 'cloude-eff48',
    authDomain: 'cloude-eff48.firebaseapp.com',
    storageBucket: 'cloude-eff48.appspot.com',
    measurementId: 'G-XGKFR6FK9J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6aE0DFvIPopfznuUfAmcXaEfcrmodSbI',
    appId: '1:402312114878:android:ee0a66128272f4132124ef',
    messagingSenderId: '402312114878',
    projectId: 'cloude-eff48',
    storageBucket: 'cloude-eff48.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGZZ-aQX5O7D0FjuJyicEZrk2TikqdNrg',
    appId: '1:402312114878:ios:780b4cf591cf2ea92124ef',
    messagingSenderId: '402312114878',
    projectId: 'cloude-eff48',
    storageBucket: 'cloude-eff48.appspot.com',
    iosClientId: '402312114878-55n2mk3b003l6hd3d9tgisils7q5l707.apps.googleusercontent.com',
    iosBundleId: 'com.example.cloude',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGZZ-aQX5O7D0FjuJyicEZrk2TikqdNrg',
    appId: '1:402312114878:ios:c85fe23bccbd9de32124ef',
    messagingSenderId: '402312114878',
    projectId: 'cloude-eff48',
    storageBucket: 'cloude-eff48.appspot.com',
    iosClientId: '402312114878-fbn6g9os65lgo3b8caar06o91seaogpk.apps.googleusercontent.com',
    iosBundleId: 'com.example.cloude.RunnerTests',
  );
}
