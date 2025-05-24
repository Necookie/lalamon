import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUserRoles() async {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  try {
    final querySnapshot = await usersCollection.get();

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final email = data['email'] as String? ?? '';

      String role = 'user';
      if (email == 'admin@admin.com') {
        role = 'admin';
      }

      await usersCollection.doc(doc.id).update({'role': role});
      print('Updated ${doc.id} with role $role');
    }

    print('All user roles updated.');
  } catch (e) {
    print('Error updating roles: $e');
  }
}
