import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.pinkAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar(context, "Passwords don't match. Please make sure both passwords are identical.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create auth account
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Create user document in Firestore with default nickname
      final nickname = _emailController.text.trim().split('@')[0];
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'email': _emailController.text.trim(),
        'name': nickname,
        'phone': '',
        'createdAt': FieldValue.serverTimestamp(),
        'avatarSeed': nickname, // Use nickname as initial avatar seed
      });

      if (mounted) {
        _showSuccessSnackBar(context, "Welcome to Lalamon! Your account has been created successfully.");
        // Small delay to show the success message
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        final errorMessage = switch (e.code) {
          'weak-password' => 'Password is too weak. Please use at least 6 characters with a mix of letters and numbers.',
          'email-already-in-use' => 'An account already exists for this email. Please try logging in instead.',
          'invalid-email' => 'The email address is not valid. Please check and try again.',
          _ => 'Registration failed: ${e.message ?? "Unknown error occurred"}'
        };
        _showErrorSnackBar(context, errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(
          context, 
          "Failed to create account: Network or server error. Please check your connection and try again."
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            colors: [
              Colors.pinkAccent.shade200,
              Colors.pinkAccent.shade700,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 160),
              child: Column(
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: "PoppinsFont",
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create a new account',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: double.infinity),
                            const Text(
                              'EMAIL',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Please enter a valid email format';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "example@gmail.com",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 222, 232, 237),
                                ),
                              ),
                            ),
                            const Text(
                              'PASSWORD',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "*******",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: 5,
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 222, 232, 237),
                                  suffixIcon: IconButton(
                                    onPressed: _togglePasswordVisibility,
                                    color: Colors.grey,
                                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'CONFIRM PASSWORD',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmText,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "*******",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: 5,
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 222, 232, 237),
                                  suffixIcon: IconButton(
                                    onPressed: _toggleConfirmPasswordVisibility,
                                    color: Colors.grey,
                                    icon: Icon(_obscureConfirmText ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                            FilledButton(
                              onPressed: _isLoading ? null : _signUp,
                              style: FilledButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Colors.pinkAccent,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('SIGN UP'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account?  "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'LOG IN',
                                      style: TextStyle(
                                        color: Colors.pinkAccent,
                                      ),
                                    ),
                                  ),
                                ],
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
