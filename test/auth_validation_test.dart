import 'package:flutter_test/flutter_test.dart';
import 'package:nine/services/auth_service.dart';

void main() {
  test(
    'email validation requires a complete address and ignores outer spaces',
    () {
      expect(validateEmail(null), 'Enter your email address.');
      expect(validateEmail('   '), 'Enter your email address.');
      expect(validateEmail('member@'), 'Enter a valid email address.');
      expect(
        validateEmail('member name@example.com'),
        'Enter a valid email address.',
      );
      expect(validateEmail(' member+assessment@example.com '), isNull);
    },
  );

  test('password validation requires a value and preserves whitespace', () {
    expect(validatePassword(null), 'Enter your password.');
    expect(validatePassword(''), 'Enter your password.');
    expect(validatePassword(' pass phrase '), isNull);
  });

  test('Firebase errors map to friendly, consistent messages', () {
    for (final code in [
      'invalid-credential',
      'user-not-found',
      'wrong-password',
    ]) {
      expect(
        AuthFailure.fromCode(code).message,
        'The email or password is incorrect.',
      );
    }
    expect(
      AuthFailure.fromCode('network-request-failed').message,
      'Check your internet connection and try again.',
    );
    expect(
      AuthFailure.fromCode('unknown').message,
      'Sign-in failed. Please try again.',
    );
  });
}
