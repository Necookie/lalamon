import 'package:firebase_auth/firebase_auth.dart';

Future<String?> sendPasswordResetEmailBackend(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return null; // Success, no error
  } catch (e) {
    return e.toString(); // Return error message
  }
}
