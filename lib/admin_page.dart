import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPanelHome extends StatefulWidget {
  const AdminPanelHome({super.key});

  @override
  State<AdminPanelHome> createState() => _AdminPanelHomeState();
}

class _AdminPanelHomeState extends State<AdminPanelHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _promoteToAdmin(String userId) async {
    await _firestore.collection('users').doc(userId).update({'role': 'admin'});
  }

  Future<void> _demoteToUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({'role': 'user'});
  }

  Future<void> _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;
              final role = data['role'] ?? 'user';
              final name = data['name'] ?? 'No Name';
              final email = data['email'] ?? 'No Email';

              return ListTile(
                title: Text(name),
                subtitle: Text(email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (role != 'admin')
                      IconButton(
                        icon: const Icon(Icons.upgrade, color: Colors.green),
                        tooltip: 'Promote to Admin',
                        onPressed: () => _promoteToAdmin(user.id),
                      ),
                    if (role == 'admin')
                      IconButton(
                        icon: const Icon(Icons.downhill_skiing, color: Colors.orange),
                        tooltip: 'Demote to User',
                        onPressed: () => _demoteToUser(user.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete User',
                      onPressed: () async {
                        bool confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text('Delete user "$name"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm) {
                          await _deleteUser(user.id);
                        }
                      },
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: role == 'admin' ? Colors.pinkAccent : Colors.grey,
                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
