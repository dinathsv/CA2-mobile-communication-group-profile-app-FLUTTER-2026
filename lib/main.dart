import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'services/auth_service.dart';

const _webFirebaseOptions = FirebaseOptions(
  apiKey: String.fromEnvironment('apiKey'),
  appId: String.fromEnvironment('appId'),
  messagingSenderId: String.fromEnvironment('messagingSenderId'),
  projectId: String.fromEnvironment('projectId'),
  authDomain: String.fromEnvironment('authDomain'),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb && _webFirebaseOptions.appId.isEmpty) {
      throw StateError(
        'Pass the Firebase web config with --dart-define-from-file.',
      );
    }
    // Android reads the native resources generated from google-services.json.
    await Firebase.initializeApp(options: kIsWeb ? _webFirebaseOptions : null);
  } catch (error) {
    debugPrint('Firebase initialization failed: $error');
    runApp(const FirebaseSetupApp());
    return;
  }

  runApp(NineApp(auth: FirebaseAuthService()));
}
