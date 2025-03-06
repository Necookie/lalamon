import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true; // Password visibility state

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Toggle the password visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // To keep the layout intact on different devices
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
              Colors.pinkAccent.shade200, // Lighter shade on top
              Colors.pinkAccent.shade700, // Darker shade on bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 160),
              child: Column(
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: "PoppinsFont",
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Create a new account',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: double.infinity),
                          Text(
                            'EMAIL',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "example@gmail.com",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 222, 232, 237),
                              ),
                            ),
                          ),
                          Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "*******",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 5,
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 222, 232, 237),
                                suffixIcon: IconButton(
                                  onPressed: _togglePasswordVisibility,
                                  color: Colors.grey,
                                  icon: Icon(Icons.visibility),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'CONFIRM PASSWORD',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "*******",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: 5,
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 222, 232, 237),
                                suffixIcon: IconButton(
                                  onPressed: _togglePasswordVisibility,
                                  color: Colors.grey,
                                  icon: Icon(Icons.visibility),
                                ),
                              ),
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              // Implement your sign-up logic here
                              print('Sign Up button pressed');
                            },
                            style: FilledButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.pinkAccent,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('SIGN UP'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?  "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
