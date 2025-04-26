import 'package:flutter/material.dart';
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
      {'name': 'hell\'s kitchen Burger', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Hells_Kitchen_Burger.jpg'},
      {'name': 'hellfire Chicken Burger', 'price': '₱130', 'imageUrl': 'lib/Assets/images/Hellfire_Chicken_Burger.png'},
      {'name': 'Juicy Lucy Burger', 'price': '₱140', 'imageUrl': 'lib/Assets/images/Juicy_Lucy.jpg'},
      {'name': 'Jalapeno-onion Burger', 'price': '₱120', 'imageUrl': 'lib/Assets/images/Jalapeno-Onion_Smash_Burger.jpg'},
      {'name': 'Japanese-Style Chili', 'price': '₱150', 'imageUrl': 'lib/Assets/images/Japanese-Style_Chili_Burgers_with_Yuzu_Mayo.jpg'},
      {'name': 'Veggie Burger', 'price': '₱80', 'imageUrl': 'lib/Assets/images/burger.jpeg'},
    ],
    // Add other categories...
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
