import 'package:flutter/material.dart';
import 'package:lalamon/cart_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
// ignore: avoid_web_libraries_in_flutter


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

  Future<void> saveOrderToFirestore({required String paymentMethod, required double totalAmount}) async {
    final user = FirebaseAuth.instance.currentUser;
    final cartItems = CartManager().cartItems;

    print('Saving order to Firestore...');
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user?.uid ?? 'guest',
      'userEmail': user?.email ?? '',
      'userName': user?.displayName ?? '',
      'address': addressController.text,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'status': 'Pending', // or 'Processing'
      'createdAt': FieldValue.serverTimestamp(),
      'items': cartItems.map((item) => {
        'name': item['name'],
        'quantity': item['quantity'],
        'price': item['price'],
        'imageUrl': item['imageUrl'],
      }).toList(),
    });
    print('Order saved!');
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
            (selectedPayment == 'PayPal')
              ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (kIsWeb) {
                        // Web: Show a message or handle PayPal with a web-only solution.
                        // You CANNOT use html.window.open here unless you import dart:html, which breaks mobile.
                        // So, for emulator/mobile, just show a message:
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('PayPal payment is only available on web.')),
                        );
                      } else {
                        // Mobile: Use UsePaypal widget as before
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => UsePaypal(
                              sandboxMode: true,
                              clientId: "AQIxzp_Jt2uB0gBb2Lr-enUZxaqPEbQPH2IXRCyMmo3FU0Rc77bXyBHknVlMOMiAH1ixCovAHY2tMZyv",
                              secretKey: "EAk9qMMflY0jBmO-HmGpHc9ZCrjf1wolcfQQIOfDQDfmS9LTp2aYVwX60-qVavq8COhniz160fm2Tlgv",
                              returnURL: "https://samplesite.com/return",
                              cancelURL: "https://samplesite.com/cancel",
                              transactions: [
                                {
                                  "amount": {
                                    "total": totalPrice.toStringAsFixed(2),
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": totalPrice.toStringAsFixed(2),
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description": "Order payment",
                                  "item_list": {
                                    "items": CartManager().cartItems.map((item) => {
                                      "name": item['name'],
                                      "quantity": item['quantity'].toString(),
                                      "price": item['price'].toString(),
                                      "currency": "USD"
                                    }).toList(),
                                  }
                                }
                              ],
                              note: "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                await saveOrderToFirestore(
                                  paymentMethod: 'PayPal',
                                  totalAmount: totalPrice,
                                );
                                await updateStockAfterOrder();
                                CartManager().clear();
                                if (!mounted) return;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Order Successful'),
                                    content: const Text('Your order has been placed and paid via PayPal!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Payment error: $error'))
                                );
                              },
                              onCancel: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Payment cancelled'))
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Pay with PayPal'),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Place Order pressed');
                      if (addressController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter your address.')),
                        );
                        return;
                      }
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Confirm Order'),
                          content: const Text('Are you sure you want to place this order?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext); // Close dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext); // Close confirm dialog

                                await saveOrderToFirestore(
                                  paymentMethod: selectedPayment,
                                  totalAmount: totalPrice,
                                );
                                await updateStockAfterOrder();

                                if (!mounted) return;

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Order Successful'),
                                    content: const Text('Your order has been placed successfully!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          CartManager().clear();
                                          setState(() {});
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