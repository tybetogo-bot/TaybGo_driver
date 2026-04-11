import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration generated from google-services.json and
/// GoogleService-Info.plist for the tybetogodriver project.
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
    apiKey: 'AIzaSyDa0R4NIDT7yFqzNmyedYpKQo3IXOeMjhc',
    appId: '1:356779144732:web:25604849c62be4d2bdd1d9',
    messagingSenderId: '356779144732',
    projectId: 'tybetogodriver',
    storageBucket: 'tybetogodriver.firebasestorage.app',
    authDomain: 'tybetogodriver.firebaseapp.com',
    measurementId: 'G-PXSLY985VL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByvlXL4wEbxKrQHukO8hqmyivQ4j5VMqc',
    appId: '1:527527512549:android:363c47f483e2029cd1c70c',
    messagingSenderId: '527527512549',
    projectId: 'drivertaybgo',
    storageBucket: 'drivertaybgo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUiaZ2aHASy3O9OrVHWzYeBlvrKhvL1qU',
    appId: '1:356779144732:ios:6a691394556249e1bdd1d9',
    messagingSenderId: '356779144732',
    projectId: 'tybetogodriver',
    storageBucket: 'tybetogodriver.firebasestorage.app',
    iosBundleId: 'com.tybetogo.driver',
  );
}
