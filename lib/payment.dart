import 'package:flutter/material.dart';
import 'home.dart'; // Import the Home screen for navigation
import 'card_fill_up_form.dart'; // Import the CardFillUpForm screen

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Add functionality for adding a payment method here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CardFillUpForm(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Payment Method:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 15, 12, 13),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'lib/Assets/images/PayPal_Logo.png', // Replace with your Visa logo path
                        width: 40, // Small size for the logo
                        height: 20,
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}