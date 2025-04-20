import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryTitle;

  const CategoryDetailsPage({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    // Mock data for items in each category
    final Map<String, List<Map<String, String>>> categoryItems = {
      'Pizza': [
        {'name': 'Margherita', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Margherita_Pizza.jpeg'},
        {'name': 'Pepperoni', 'price': '₱200', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Nepolitan', 'price': '₱250', 'imageUrl': 'lib/Assets/images/Neapolitan_Pizza.jpg'},
        {'name': 'Pizza Al Taglio', 'price': '₱180', 'imageUrl': 'lib/Assets/images/Pizza_al_taglio.jpg'},
        {'name': 'Chicago Deep Dish', 'price': '₱300', 'imageUrl': 'lib/Assets/images/Chicago_Deep_Dish_Pizza.jpg'},
        {'name': 'New York Style', 'price': '₱250', 'imageUrl': 'lib/Assets/images/New_York_Style_Pizza.jpg'},
      ],
      'Burger': [
        {'name': 'Cheeseburger', 'price': '₱100', 'imageUrl': 'lib/Assets/images/Cheese_Burger.jpg'},
        {'name': 'Hatch Chile Burger', 'price': '₱120', 'imageUrl': 'lib/Assets/images/Hatch_Chile_Smash_Burgers.jpg'},
        {'name': 'hell\'s kitchen Burger', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Hells_Kitchen_Burger.jpg'},
        {'name': 'hellfire Chicken Burger', 'price': '₱130', 'imageUrl': 'lib/Assets/images/Hellfire_Chicken_Burger.png'},
        {'name': 'Juicy Lucy Burger', 'price': '₱140', 'imageUrl': 'lib/Assets/images/Juicy_Lucy.jpg'},
        {'name': 'Jalapeno-onion Burger', 'price': '₱120', 'imageUrl': 'lib/Assets/images/Jalapeno-Onion_Smash_Burger.jpg'},
        {'name': 'Japanese-Style Chili', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Japanese-Style_Chili_Burgers_with_Yuzu_Mayo.jpg'},
        {'name': 'Veggie Burger', 'price': '₱80', 'imageUrl': 'lib/Assets/images/burger.jpeg'},
      ],
      'Chicken': [
        {'name': 'Grilled Chicken', 'price': '₱200', 'imageUrl': 'lib/Assets/images/Fried_Chicken.jpg'},
        {'name': 'Roast Chicken', 'price': '₱180', 'imageUrl': 'lib/Assets/images/Roast_Chicken.jpg'},
        {'name': 'BBQ Chicken', 'price': '₱220', 'imageUrl': 'lib/Assets/images/BBQ_Chicken.jpg'},
        {'name': 'Chicken Parmesan', 'price': '₱250', 'imageUrl': 'lib/Assets/images/Chicken_Parmesan.jpg'},
        {'name': 'Chicken Alfredo', 'price': '₱230', 'imageUrl': 'lib/Assets/images/Chicken_Alfredo.jpg'},
      ],
      'Spaghetti': [
        {'name': 'Italian Spaghetti', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Spaghetti.jpg'},
        {'name': 'Linguine', 'price': '₱180', 'imageUrl': 'lib/Assets/images/Linguine.jpg'},
        {'name': 'Lasagne alla Bologmese', 'price': '₱200', 'imageUrl': 'lib/Assets/images/Lasagne_alla_Bolognese.jpg'},
      ],
      'Drinks': [
        {'name': 'Coca Cola', 'price': '₱30', 'imageUrl': 'lib/Assets/images/Coca_Cola.jpg'},
        {'name': 'Dr. Pepper', 'price': '₱35', 'imageUrl': 'lib/Assets/images/Dr_Pepper.jpeg'},
        {'name': 'Pepsi', 'price': '₱30', 'imageUrl': 'lib/Assets/images/Pepsi.jpg'},
        {'name': 'Fanta', 'price': '₱25', 'imageUrl': 'lib/Assets/images/Fanta.jpg'},
        {'name': 'Sprite', 'price': '₱30', 'imageUrl': 'lib/Assets/images/Sprite.jpg'},
        {'name': 'Mountain Dew', 'price': '₱35', 'imageUrl': 'lib/Assets/images/Mountain_Dew.jpg'},
      ],
    };

    // Get the items for the selected category
    final items = categoryItems[categoryTitle] ?? [];

    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate card width and height dynamically
    final cardWidth = (screenWidth - 30) / 2; // Subtract padding and divide by 2 for two columns
    final cardHeight = cardWidth * 1.2; // Adjust height based on width (aspect ratio)

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10, // Spacing between columns
            mainAxisSpacing: 10, // Spacing between rows
            childAspectRatio: cardWidth / cardHeight, // Dynamic aspect ratio
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () {
                // Navigate to the placeholder page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceholderPage(
                      productName: item['name']!,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Item image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              item['imageUrl']!,
                              height: cardHeight * 0.6, // Adjust image height relative to card height
                              width: cardWidth, // Adjust image width relative to card width
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Item name
                          Text(
                            item['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // Price at the bottom-right
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Text(
                          item['price']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
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
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String productName;

  const PlaceholderPage({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Center(
        child: Text('Details for $productName'),
      ),
    );
  }
}