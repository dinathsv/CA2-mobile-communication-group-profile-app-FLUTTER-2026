import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // The Android Gradle plugin turns FlutterFire's google-services.json into
    // native resources that Firebase uses to initialize the default app.
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint('Firebase initialization failed: $error');
    runApp(const FirebaseSetupApp());
    return;
  }

  runApp(NineApp(auth: FirebaseAuthService()));
}
