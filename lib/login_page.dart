import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lalamon/register_page.dart';
import 'package:lalamon/forgotpass_page.dart';
import 'package:lalamon/home.dart';
import 'package:lalamon/admin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isChecked = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showSnackBar(BuildContext context, String message, Color color, Icon icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _navigateBasedOnRole(User user) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  print('User UID: ${user.uid}');
  print('Document exists: ${doc.exists}');
  print('Document data: ${doc.data()}');
  print('Role: ${doc.data()?['role']}');

  final role = doc.data()?['role'];

  if (mounted) {
    if (role == 'admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminPanelHome()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
    }
  }
}


  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        _showSnackBar(context, "Login successful!", Colors.green.shade600, const Icon(Icons.check_circle, color: Colors.white));
        await Future.delayed(const Duration(seconds: 1));
        await _navigateBasedOnRole(credential.user!);
      }
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'user-not-found' => 'No user found with this email',
        'wrong-password' => 'Wrong password provided',
        'invalid-email' => 'Please enter a valid email address',
        'user-disabled' => 'This account has been disabled',
        _ => 'An error occurred. Please try again later'
      };
      _showSnackBar(context, message, Colors.pinkAccent.shade700, const Icon(Icons.error_outline, color: Colors.white));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (mounted) {
        _showSnackBar(context, "Google Sign-In successful!", Colors.green.shade600, const Icon(Icons.check_circle, color: Colors.white));
        await Future.delayed(const Duration(seconds: 1));
        await _navigateBasedOnRole(userCredential.user!);
      }
    } catch (e) {
      _showSnackBar(context, "Google Sign-In failed", Colors.pinkAccent.shade700, const Icon(Icons.error_outline, color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pinkAccent.shade200, Colors.pinkAccent.shade700],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 160),
              child: Column(
                children: [
                  const Text('Log In', style: TextStyle(fontFamily: "PoppinsFont", fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white)),
                  const SizedBox(height: 10),
                  const Text('Please sign in to your existing account', style: TextStyle(fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('EMAIL', style: TextStyle(fontSize: 20)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter your email';
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Please enter a valid email';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "example@gmail.com",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 222, 232, 237),
                                ),
                              ),
                            ),
                            const Text('PASSWORD', style: TextStyle(fontSize: 20)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter your password';
                                  if (value.length < 6) return 'Password must be at least 6 characters';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "*******",
                                  hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 5),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 222, 232, 237),
                                  suffixIcon: IconButton(
                                    onPressed: _togglePasswordVisibility,
                                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (value) => setState(() => _isChecked = value ?? false),
                                      side: const BorderSide(color: Colors.grey),
                                      activeColor: Colors.pink,
                                    ),
                                    const Text('Remember me', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPassPage())),
                                  child: const Text('Forgot Password', style: TextStyle(color: Colors.pinkAccent)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: _isLoading ? null : _login,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('LOG IN'),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(text: 'Don\'t have an account? ', style: TextStyle(color: Colors.black)),
                                      const TextSpan(text: 'Sign Up', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                            const Center(child: Text('or continue with', style: TextStyle(fontSize: 16, color: Colors.pinkAccent, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: _signInWithGoogle,
                                child: Container(
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset('lib/Assets/images/google_logo.png', width: 40, height: 40),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
