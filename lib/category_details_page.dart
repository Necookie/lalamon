import 'package:flutter/material.dart';
import 'package:lalamon/product_details.dart';
import 'search_bar.dart' as custom_search; // Alias the import

class CategoryDetailsPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryDetailsPage({super.key, required this.categoryTitle});

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  String _searchQuery = '';

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
        {'name': 'Hell\'s Kitchen Burger', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Hells_Kitchen_Burger.jpg'},
      {'name': 'Hellfire Chicken Burger', 'price': '₱130', 'imageUrl': 'lib/Assets/images/Hellfire_Chicken_Burger.png'},
      {'name': 'Juicy Lucy Burger', 'price': '₱140', 'imageUrl': 'lib/Assets/images/Juicy_Lucy.jpg'},
      {'name': 'Jalapeno-Onion Burger', 'price': '₱120', 'imageUrl': 'lib/Assets/images/Jalapeno-Onion_Smash_Burger.jpg'},
      {'name': 'Japanese-Style Chili', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Japanese-Style_Chili_Burgers_with_Yuzu_Mayo.jpg'},
      {'name': 'Veggie Burger', 'price': '₱80', 'imageUrl': 'lib/Assets/images/burger.jpeg'},
    ],
    'Chicken': [
      {'name': 'Fried Chicken', 'price': '₱180', 'imageUrl': 'lib/Assets/images/Fried_Chicken.jpg'},
      {'name': 'BBQ Chicken', 'price': '₱220', 'imageUrl': 'lib/Assets/images/BBQ_Chicken.jpg'},
      {'name': 'Chicken Parmesan', 'price': '₱250', 'imageUrl': 'lib/Assets/images/Chicken_Parmesan.jpg'},
      {'name': 'Chicken Alfredo', 'price': '₱230', 'imageUrl': 'lib/Assets/images/Chicken_Alfredo.jpg'},
    ],
    'Spaghetti': [
      {'name': 'Italian Spaghetti', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Spaghetti.jpg'},
      {'name': 'Linguine', 'price': '₱180', 'imageUrl': 'lib/Assets/images/Linguine.jpg'},
      {'name': 'Lasagne alla Bolognese', 'price': '₱200', 'imageUrl': 'lib/Assets/images/Lasagne_alla_Bolognese.jpg'},
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 30) / 2;
    final cardHeight = cardWidth * 1.2;

    final items = categoryItems[widget.categoryTitle] ?? [];

    // Apply search filter
    final filteredItems = items.where((item) {
      final name = item['name']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: custom_search.SearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value; // Update the search query
                  });
                },
                onSearch: () {
                  setState(() {
                    // Perform filtering when the search button is pressed
                    // The query is already filtered as the search query is stored in _searchQuery
                  });
                },
              ),
            ),
            // Grid view
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: cardWidth / cardHeight,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            productName: item['name']!,
                            productPrice: item['price']!,
                            productImageUrl: item['imageUrl']!,
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    item['imageUrl']!,
                                    height: cardHeight * 0.6,
                                    width: cardWidth,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
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
          ],
        ),
      ),
    );
  }
}
