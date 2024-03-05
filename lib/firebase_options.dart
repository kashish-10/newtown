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
    apiKey: 'AIzaSyDlgYywlOqj3AKXJei-GS8SDFyE2O0ZudI',
    appId: '1:841235444956:web:dfea8ce7d53beabd427019',
    messagingSenderId: '841235444956',
    projectId: 'divaguard-d973f',
    authDomain: 'divaguard-d973f.firebaseapp.com',
    storageBucket: 'divaguard-d973f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQkDwARyLF7Kaz_-cLQth4F7xeFozcoV0',
    appId: '1:841235444956:android:fc4341289241d596427019',
    messagingSenderId: '841235444956',
    projectId: 'divaguard-d973f',
    storageBucket: 'divaguard-d973f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSLVnBdF9JkEn8QCHAZ0X-21lDBMc61us',
    appId: '1:841235444956:ios:82474f4ef75fdbc7427019',
    messagingSenderId: '841235444956',
    projectId: 'divaguard-d973f',
    storageBucket: 'divaguard-d973f.appspot.com',
    iosBundleId: 'com.example.diva',
  );
}
