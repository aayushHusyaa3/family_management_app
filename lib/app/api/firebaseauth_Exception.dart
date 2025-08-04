import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorHandler {
  static String getMessage(FirebaseAuthException e) {
    switch (e.code) {
      // ----- Common Errors -----
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'internal-error':
        return 'An internal error occurred. Please try again.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';

      // ----- Sign In Errors -----
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-credential':
        return 'The provided credentials are invalid. Please check your email and password.';

      // ----- Sign Up Errors -----
      case 'email-already-in-use':
        return 'The email address is already registered.';
      case 'weak-password':
        return 'The password is too weak. Use at least 6 characters.';

      // ----- Phone Auth Errors -----
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      case 'session-expired':
        return 'The verification session has expired. Please try again.';

      default:
        return 'An unexpected error occurred. [${e.code}]';
    }
  }
}
