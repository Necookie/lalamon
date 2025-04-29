import 'package:flutter/material.dart';
import 'product_details.dart';

class RecommendedItems extends StatelessWidget {
  final List<Map<String, String>> recommendedItems;

  const RecommendedItems({super.key, required this.recommendedItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Recommended Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendedItems.length,
            itemBuilder: (context, index) {
              final item = recommendedItems[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to ProductDetailsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        productName: item['title']!,
                        productPrice: item['price']!,
                        productImageUrl: item['imageUrl']!,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        // Background image
                        Image.asset(
                          item['imageUrl']!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.fill,
                        ),
                        // Image Overlay
                        Container(
                          height: 200,
                          width: 200,
                          color: Colors.black.withOpacity(0.3),
                        ),
                        // Overlay with title
                        Positioned(
                          top: 55,
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            child: Text(
                              item['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}