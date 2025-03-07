import 'package:flutter/material.dart';
import 'package:lalamon/register_page.dart';
import 'package:lalamon/forgotpass_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  

  @override
  State <LoginPage> createState() =>  LoginPageState();
}

class  LoginPageState extends State <LoginPage> {
  bool _obscureText = true; // Password visibility state
  bool _isChecked = false; //checkbox state  

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Toggle the password visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    //this is where you design
    double screenWidth = MediaQuery.of(context).size.width;// to keep the layout intact when on different devices
  double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
    //sum gradient design
    body: Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:  Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pinkAccent.shade200, // Lighter shade on top
          Colors.pinkAccent.shade700, // Darker shade on bottom
          ])
      ),
      //code for the 'login' and 'please sign in to your existing account
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 160),
            child: Column (
            //to put many widgets more like a column perhaps?
            children: [
              Text('Log In',
                    style: TextStyle(
                      fontFamily: "PoppinsFont",
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white
                      ) 
                      ),
            SizedBox(height: 10),
             Text('Please sign in to your existing account',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white
            ),
            ),
            
            SizedBox( height:20),
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
                      SizedBox(width: double.infinity,),
                      Text('EMAIL',
                      style: TextStyle(
                        fontSize: 20,
                      )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
                            hintText: "example@gmail.com",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 222, 232, 237)
                          ),
                        ),
                      ),
                      Text('PASSWORD',
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
                              borderSide: BorderSide.none
                            ),
                            hintText: "*******",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 5,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 222, 232, 237),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _togglePasswordVisibility();
                              },
                              color: Colors.grey,
                               icon: Icon(Icons.visibility,)
                               )
                          ),
                        ),
                        
                      ),
                      Row(// nested row to keep the checkbox and remember me on the same posiiton
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked, 
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                }
                                );},
                                side: BorderSide(color: Colors.grey),//to change the color of the border of the checkbox
                              activeColor: Colors.grey,//to change the color of the checkbox when clicked
                              checkColor: Colors.white,// color of the check inside the checkbox
                              ),
                              Text(
                                'Remember me',
                                style: TextStyle(color:Colors.grey)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => ForgotPassPage()),);//redirects to the forogt password page(kaw na bahala bik)
                            },
                            child: Text('Forgot Password',
                            style: TextStyle(
                              color: Colors.pinkAccent
                            ),
                            ),
                          )
                        ],
                      ),
                      
                      FilledButton(onPressed: () {
                        //redirects to the main app if account created succesfully else login failed(kayo na bahala dito back end pipol <3)
                      },
                      style: FilledButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.pinkAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                       child: Text('LOG IN')
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 25),
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?  "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterScreen()),);
                                //redirects to the sign up page (kaw naren dto bik)
                              },
                              child: Text('SIGN UP',
                              style: TextStyle(
                               color: Colors.pinkAccent 
                              ),),
                            )
                          ],
                         ),
                       )
                    ],
                  ),
                )
                           ),
            ]
          )
          )
        ),
      ),
    ),
    );
  }
}