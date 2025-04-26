import 'package:flutter/material.dart';
import 'package:lalamon/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url:
        'https://mgldunmyxufhvfstmird.supabase.co', // your Supabase project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1nbGR1bm15eHVmaHZmc3RtaXJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NDY0NTcsImV4cCI6MjA2MTIyMjQ1N30.zc18BZpHDg5PKOUzErLpGtBbRDCAHrZXNS8uFhAJx7o', // your anon key
  );
  runApp(FoodEcommerce());
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
        home: LoginPage());
  }
}
