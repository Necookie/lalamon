
// admin_orders.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({'status': newStatus});
  }

  Future<void> _deleteOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading orders'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;
              final customerName = data['customerName'] ?? 'No Name';
              final email = data['email'] ?? 'No Email';
              final status = data['status'] ?? 'pending';
              final totalPrice = data['totalPrice'] != null
                  ? (data['totalPrice'] as num).toStringAsFixed(2)
                  : '0.00';

              return ListTile(
                title: Text('Order by $customerName'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: $email'),
                    Text('Total: \$$totalPrice'),
                    Text('Status: ${status[0].toUpperCase()}${status.substring(1)}'),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'Delete') {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Delete order by "$customerName"?'),
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
                      if (confirm) await _deleteOrder(order.id);
                    } else {
                      await _updateOrderStatus(order.id, value.toLowerCase());
                    }
                  },
                  itemBuilder: (context) => [
                    if (status != 'pending')
                      const PopupMenuItem(value: 'Pending', child: Text('Mark as Pending')),
                    if (status != 'processing')
                      const PopupMenuItem(value: 'Processing', child: Text('Mark as Processing')),
                    if (status != 'completed')
                      const PopupMenuItem(value: 'Completed', child: Text('Mark as Completed')),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: 'Delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: status == 'completed'
                      ? Colors.green
                      : status == 'processing'
                          ? Colors.orange
                          : Colors.grey,
                  child: Text(customerName.isNotEmpty ? customerName[0].toUpperCase() : '?'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}