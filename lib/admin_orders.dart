// admin_orders.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final items = order['items'] as List<dynamic>? ?? [];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Order by: ${order['userName'] ?? 'Unknown'} (${order['userEmail'] ?? ''})'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${order['address'] ?? ''}'),
                      Text('Payment: ${order['paymentMethod'] ?? ''}'),
                      Text('Status: ${order['status'] ?? ''}'),
                      Text('Total: ₱${order['totalAmount'] ?? ''}'),
                      Text('Date: ${order['createdAt'] != null ? (order['createdAt'] as Timestamp).toDate().toString() : ''}'),
                      const SizedBox(height: 4),
                      Text(
                        'Items: ${items.map((item) => '${item['name']} x${item['quantity']}').join(', ')}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Optionally show more order details or actions
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}