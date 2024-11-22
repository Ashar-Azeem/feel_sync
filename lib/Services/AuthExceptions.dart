import 'package:firebase_auth/firebase_auth.dart';

String getFirebaseAuthErrorMessage(FirebaseAuthException error) {
  switch (error.code) {
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'This user account has been disabled.';
    case 'user-not-found':
      return 'No user found with this email.';
    case 'wrong-password':
      return 'The password is incorrect.';
    case 'email-already-in-use':
      return 'The email is already in use by another account.';
    case 'operation-not-allowed':
      return 'This operation is not allowed.';
    case 'weak-password':
      return 'The password is too weak.';
    case 'network-request-failed':
      return 'Network error. Please check your connection.';
    default:
      return 'An unknown error occurred. Please try again.';
  }
}
