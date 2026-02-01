import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration generated from google-services.json and
/// GoogleService-Info.plist for the tybetogodriver project.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'No Firebase configuration found for web. '
        'Run `flutterfire configure` to generate one.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATutMN0TyF1gVEkalzAl7YmgRVHEDsU_E',
    appId: '1:356779144732:android:bc37d5ff8c8466a5bdd1d9',
    messagingSenderId: '356779144732',
    projectId: 'tybetogodriver',
    storageBucket: 'tybetogodriver.firebasestorage.app',
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
