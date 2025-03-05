import 'package:flutter/material.dart';
import 'package:lalamon/login_page.dart';

void main () {
  runApp(FoodEcommerce());
}

class FoodEcommerce extends StatelessWidget {
  const FoodEcommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
      ),
      home: LoginPage(

      )
    );
  }
}