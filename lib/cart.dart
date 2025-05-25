import 'package:flutter/material.dart';
import 'package:lalamon/cart_manager.dart';
import 'CheckOutPage.dart'; // Import the CheckOutPage

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Calculate total price
  double get totalPrice {
    return CartManager().cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void _editItem(int index) {
    final item = CartManager().cartItems[index];
    final TextEditingController nameController = TextEditingController(text: item['name']);
    final TextEditingController priceController = TextEditingController(text: item['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  CartManager().cartItems[index]['name'] = nameController.text;
                  CartManager().cartItems[index]['price'] = double.tryParse(priceController.text) ?? item['price'];
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.pinkAccent,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: CartManager().cartItems.length,
                itemBuilder: (context, index) {
                  final item = CartManager().cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: (item['imageUrl'] != null && (item['imageUrl'].toString().startsWith('http') || item['imageUrl'].toString().startsWith('https')))
                            ? Image.network(
                                item['imageUrl'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                item['imageUrl'] ?? '',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                      title: Text(item['name']),
                      subtitle: Row(
                        children: [
                          // Decrement Button
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.black), // Set icon color to black
                            onPressed: () {
                              setState(() {
                                if (item['quantity'] > 1) {
                                  item['quantity']--;
                                }
                              });
                            },
                          ),

                          // Quantity Display
                          Text(
                            '${item['quantity']}',
                            style: const TextStyle(fontSize: 16),
                          ),

                          // Increment Button
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.black), // Set icon color to black
                            onPressed: () {
                              setState(() {
                                item['quantity']++;
                              });
                            },
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black), // Set icon color to black
                            onPressed: () {
                              _editItem(index);
                            },
                          ),

                          // Delete Button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black), // Set icon color to black
                            onPressed: () {
                              setState(() {
                                CartManager().removeItem(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Total Price Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
            ),

            const SizedBox(height: 20),

            // Checkout Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the CheckOutPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckOutPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent, // Set button color to pink
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}