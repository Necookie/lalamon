import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Us!!!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                      shadows: [
                        Shadow(
                          color: Colors.black12, // Shadow color
                          offset: Offset(2, 2), // Position of the shadow (x, y)
                          blurRadius: 4, // Blur effect of the shadow
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We are Computer Studies students from Laguna State Polytechnic University, united in purpose and passion, under the dual leadership of Lightbearer Lord Dheyn and Shadow Sovereign Emperor Mateo—husband and husband. Together, we created Lalamon, a food-ordering application that brings the convenience of modern dining to your fingertips.\n\n'
                    'Lalamon is more than a school project. It’s a harmonious fusion of vision and discipline—crafted through the unity of two forces: light and darkness. Developed with Flutter and powered by Firebase, it offers real-time food ordering, seamless UI/UX, and a smooth, intuitive experience for users.\n\n'
                    'As rulers of this digital dominion, Lord Dheyn\'s clarity and warmth guide the user experience, while Emperor Mateo\'s precision and depth shape the system’s backbone. Together, we built Lalamon not only to serve but to inspire.\n\n'
                    'In the realm of code, design, and innovation—we are one.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5, // Line height for better readability
                    ),
                    textAlign: TextAlign.justify, // Justify the text for a clean look
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