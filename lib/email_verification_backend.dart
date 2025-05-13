import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationBackend {
  // Send email verification
  static Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        throw Exception('Error sending verification email: $e');
      }
    } else if (user == null) {
      throw Exception('No user is currently logged in.');
    } else if (user.emailVerified) {
      throw Exception('Email is already verified.');
    }
  }
}
