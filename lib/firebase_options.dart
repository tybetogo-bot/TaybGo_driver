import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration generated from google-services.json and
/// GoogleService-Info.plist for the drivertaybgo project.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyACQ3YTugn8nEHpMLkYP6LDHPXWOpCv_B0',
    appId: '1:527527512549:web:0730fc8535383822d1c70c',
    messagingSenderId: '527527512549',
    projectId: 'drivertaybgo',
    storageBucket: 'drivertaybgo.firebasestorage.app',
    authDomain: 'drivertaybgo.firebaseapp.com',
    measurementId: 'G-GW9V84HBQ5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByvlXL4wEbxKrQHukO8hqmyivQ4j5VMqc',
    appId: '1:527527512549:android:363c47f483e2029cd1c70c',
    messagingSenderId: '527527512549',
    projectId: 'drivertaybgo',
    storageBucket: 'drivertaybgo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzOao6qpoVhY3mx27AyTroCm0P1qHK9xk',
    appId: '1:527527512549:ios:00b7019ba2761a44d1c70c',
    messagingSenderId: '527527512549',
    projectId: 'drivertaybgo',
    storageBucket: 'drivertaybgo.firebasestorage.app',
    iosBundleId: 'com.tybetogo.driver',
  );
}
