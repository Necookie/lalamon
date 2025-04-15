import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryTitle;

  const CategoryDetailsPage({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    // Mock data for items in each category
    final Map<String, List<Map<String, String>>> categoryItems = {
      'Pizza': [
        {'name': 'Margherita', 'price': '\$10', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Pepperoni', 'price': '\$12', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Matthew', 'price': '\$10', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Dheyn', 'price': '\$12', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Margherita', 'price': '\$10', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Pepperoni', 'price': '\$12', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Matthew', 'price': '\$10', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        {'name': 'Dheyn', 'price': '\$12', 'imageUrl': 'lib/Assets/images/pizza.jpeg'},
        
      ],
      'Burger': [
        {'name': 'Cheeseburger', 'price': '\$8', 'imageUrl': 'lib/Assets/images/burger.jpeg'},
        {'name': 'Veggie Burger', 'price': '\$7', 'imageUrl': 'lib/Assets/images/burger.jpeg'},
      ],
    };

    // Get the items for the selected category
    final items = categoryItems[categoryTitle] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10, // Spacing between columns
            mainAxisSpacing: 10, // Spacing between rows
            childAspectRatio: 1, // Make the cards square
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Item image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          item['imageUrl']!,
                          height: 130,
                          width: 180,
                          fit: BoxFit.fill,
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
                      const SizedBox(height: 5),
                      // Item price
                      Text(
                        item['price']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.pink,
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