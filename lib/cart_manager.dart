import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addItem(Map<String, dynamic> item) {
    // If item already exists, just increase quantity
    final index = _cartItems.indexWhere((e) => e['name'] == item['name']);
    if (index != -1) {
      _cartItems[index]['quantity'] += item['quantity'];
    } else {
      _cartItems.add(item);
    }
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
  }

  void clear() {
    _cartItems.clear();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Manager'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await saveOrderToFirestore(paymentMethod: 'Test', totalAmount: 123);
          },
          child: Text('Test Save Order'),
        ),
      ),
    );
  }

  Future<void> saveOrderToFirestore(
      {required String paymentMethod, required double totalAmount}) async {
    // Your Firestore saving logic here
  }
}