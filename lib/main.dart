import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';
import 'package:lalamon/login_page.dart';
import 'package:lalamon/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://mgldunmyxufhvfstmird.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1nbGR1bm15eHVmaHZmc3RtaXJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NDY0NTcsImV4cCI6MjA2MTIyMjQ1N30.zc18BZpHDg5PKOUzErLpGtBbRDCAHrZXNS8uFhAJx7o',
  );

  runApp(const FoodEcommerce());
}

class FoodEcommerce extends StatelessWidget {
  const FoodEcommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PoppinsFont',
      ),
      home: SplashScreen(),
    );
  }
}
