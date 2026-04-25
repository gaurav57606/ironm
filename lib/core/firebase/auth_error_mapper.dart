/// Maps Firebase Auth error codes to human-readable messages in Indian English.
class AuthErrorMapper {
  static String map(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a few minutes.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
