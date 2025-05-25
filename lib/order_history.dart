import 'package:flutter/material.dart';

class OrdersHistoryPage extends StatelessWidget {
  const OrdersHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration. Replace with Firestore query in production.
    final currentOrders = [
      {
        'orderId': 'ORD12345',
        'date': '2024-06-01',
        'status': 'Pending',
        'total': 350.0,
        'items': [
          {'name': 'Cheeseburger', 'quantity': 2},
          {'name': 'Pizza', 'quantity': 1},
        ],
      },
    ];

    final orderHistory = [
      {
        'orderId': 'ORD12344',
        'date': '2024-05-28',
        'status': 'Completed',
        'total': 200.0,
        'items': [
          {'name': 'Veggie Burger', 'quantity': 1},
        ],
      },
      {
        'orderId': 'ORD12343',
        'date': '2024-05-20',
        'status': 'Cancelled',
        'total': 180.0,
        'items': [
          {'name': 'Fried Chicken', 'quantity': 2},
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders & History'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Current Orders',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          ...currentOrders.map((order) => Card(
                child: ListTile(
                  title: Text('Order #${order['orderId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${order['date']}'),
                      Text('Status: ${order['status']}'),
                      Text('Total: ₱${order['total']}'),
                      const SizedBox(height: 4),
                      Text(
                        'Items: ' +
                            (order['items'] as List)
                                .map((item) =>
                                    '${item['name']} x${item['quantity']}')
                                .join(', '),
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
                  title: Text('Order #${order['orderId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${order['date']}'),
                      Text('Status: ${order['status']}'),
                      Text('Total: ₱${order['total']}'),
                      const SizedBox(height: 4),
                      Text(
                        'Items: ' +
                            (order['items'] as List)
                                .map((item) =>
                                    '${item['name']} x${item['quantity']}')
                                .join(', '),
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
      ),
    );
  }
}