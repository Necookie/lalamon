import 'package:firebase_auth/firebase_auth.dart';

class ErrorMessages {
  static String getProfileLoadError(dynamic error) {
    if (error is FirebaseException) {
      return 'Failed to load profile: ${error.message ?? 'Database error occurred'}';
    }
    return 'Failed to load profile: Network or connection error. Please check your internet connection.';
  }

  static String getProfileUpdateError(dynamic error) {
    if (error is FirebaseException) {
      return 'Failed to update profile: ${error.message ?? 'Database error occurred'}';
    }
    return 'Failed to update profile: Network or connection error. Please try again.';
  }

  static String getPasswordChangeError(dynamic error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'weak-password' => 'New password is too weak. Please use at least 6 characters with a mix of letters and numbers.',
        'requires-recent-login' => 'Please log out and log back in before changing your password for security.',
        'wrong-password' => 'Current password is incorrect. Please double-check your current password.',
        _ => 'Failed to change password: ${error.message ?? 'Authentication error occurred'}'
      };
    }
    return 'Failed to change password: Network or connection error. Please try again.';
  }

  static String getSignOutError(dynamic error) {
    if (error is FirebaseAuthException) {
      return 'Failed to sign out: ${error.message ?? 'Authentication error occurred'}';
    }
    return 'Failed to sign out: Please check your internet connection and try again.';
  }
}
