import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthService {
  Stream<String?> authStateChanges();
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService() : _auth = FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<String?> authStateChanges() =>
      _auth.authStateChanges().map((user) => user?.uid);

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure.fromCode(error.code);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  factory AuthFailure.fromCode(String code) {
    final message = switch (code) {
      'invalid-credential' ||
      'invalid-login-credentials' ||
      'user-not-found' ||
      'wrong-password' => 'The email or password is incorrect.',
      'invalid-email' => 'Enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'network-request-failed' =>
        'Check your internet connection and try again.',
      'too-many-requests' => 'Too many attempts. Wait a moment and try again.',
      'operation-not-allowed' =>
        'Email sign-in is unavailable. Contact the group leader.',
      _ => 'Sign-in failed. Please try again.',
    };
    return AuthFailure(message);
  }

  final String message;
}

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

String? validateEmail(String? input) {
  final email = input?.trim() ?? '';
  if (email.isEmpty) return 'Enter your email address.';
  if (!_emailPattern.hasMatch(email)) return 'Enter a valid email address.';
  return null;
}

String? validatePassword(String? input) {
  if (input == null || input.isEmpty) return 'Enter your password.';
  return null;
}
