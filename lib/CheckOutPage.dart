import 'package:flutter/material.dart';
import 'package:lalamon/cart_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final TextEditingController addressController = TextEditingController();
  String selectedPayment = 'Cash on Delivery';

  double get totalPrice {
    return CartManager().cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  Future<void> updateStockAfterOrder() async {
    final cartItems = CartManager().cartItems;
    final firestore = FirebaseFirestore.instance;

    for (final item in cartItems) {
      final query = await firestore
          .collection('products')
          .where('name', isEqualTo: item['name'])
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        final currentStock = doc['stock'] ?? 0;
        final newStock = currentStock - item['quantity'];
        await doc.reference.update({'stock': newStock < 0 ? 0 : newStock});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager().cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.pinkAccent,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            const Text(
              'Delivery Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your delivery address',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Payment Method Section
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPayment,
              items: const [
                DropdownMenuItem(
                  value: 'Cash on Delivery',
                  child: Text('Cash on Delivery'),
                ),
                DropdownMenuItem(
                  value: 'PayPal',
                  child: Text('PayPal'),
                ),
                DropdownMenuItem(
                  value: 'Credit/Debit Card',
                  child: Text('Credit/Debit Card'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Order Summary Section
            const Text(
              'Order Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: (item['imageUrl'] != null &&
                            (item['imageUrl'].toString().startsWith('http') ||
                             item['imageUrl'].toString().startsWith('https')))
                        ? Image.network(
                            item['imageUrl'],
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            item['imageUrl'] ?? '',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(item['name']),
                  subtitle: Text('₱${item['price']} x ${item['quantity']}'),
                  trailing: Text(
                    '₱${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 32, thickness: 1),
            // Total Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₱${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your address.')),
                    );
                    return;
                  }
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Order'),
                      content: const Text('Are you sure you want to place this order?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context); // Close confirm dialog

                            // Update stock in Firestore
                            await updateStockAfterOrder();

                            // Show order success prompt
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: const Text('Order Success'),
                                content: const Text('Your order has been placed successfully!'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close success dialog
                                      Navigator.pop(context); // Optionally go back to previous page
                                      CartManager().clear(); // Clear the cart after order
                                      setState(() {}); // Refresh the page if needed
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                          ),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}