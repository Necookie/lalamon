import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersHistoryPage extends StatelessWidget {
  const OrdersHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders & History'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: currentUserId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data?.docs ?? [];

          // Separate current orders and order history
          final currentOrders = orders.where((order) {
            final status = order['status'] as String? ?? '';
            return status == 'Pending' || status == 'In Progress';
          }).toList();

          final orderHistory = orders.where((order) {
            final status = order['status'] as String? ?? '';
            return status == 'Completed' || status == 'Cancelled';
          }).toList();

          String formatDate(Timestamp? timestamp) {
            if (timestamp == null) return '';
            final date = timestamp.toDate();
            return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Current Orders',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              ...currentOrders.map((order) => Card(
                    child: ListTile(
                      title: Text('Order #${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${formatDate(order['createdAt'] as Timestamp?)}'),
                          Text('Status: ${order['status'] ?? ''}'),
                          Text('Total: ₱${order['totalAmount'] ?? ''}'),
                          const SizedBox(height: 4),
                          Text(
                            'Items: ${(order['items'] as List)
                                .map((item) => '${item['name']} x${item['quantity']}')
                                .join(', ')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Optionally show order details
                      },
                    ),
                  )),
              const SizedBox(height: 30),
              const Text(
                'Order History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              ...orderHistory.map((order) => Card(
                    child: ListTile(
                      title: Text('Order #${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${formatDate(order['createdAt'] as Timestamp?)}'),
                          Text('Status: ${order['status'] ?? ''}'),
                          Text('Total: ₱${order['totalAmount'] ?? ''}'),
                          const SizedBox(height: 4),
                          Text(
                            'Items: ${(order['items'] as List)
                                .map((item) => '${item['name']} x${item['quantity']}')
                                .join(', ')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Optionally show order details
                      },
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}