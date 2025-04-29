import 'package:flutter/material.dart';


class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String emoji;
    switch (title.toLowerCase()) {
      case 'pizza':
        emoji = '🍕';
        break;
      case 'burger':
        emoji = '🍔';
        break;
      case 'chicken':
        emoji = '🍗';
        break;
      case 'spaghetti':
        emoji = '🍝';
        break;
      case 'drinks':
        emoji = '🥤';
        break;
      default:
        emoji = '🍽️';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.pinkAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pinkAccent.withOpacity(0.2),
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
