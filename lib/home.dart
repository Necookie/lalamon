import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lalamon/login_page.dart';
import 'package:lalamon/profile_page.dart';
import 'all_categories_page.dart';
import 'cart.dart';
import 'category_details_page.dart';

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
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.pinkAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> categories = [
    {'title': 'Pizza', 'imageUrl': 'lib/Assets/images/pizza.jpeg', 'price': '₱150'},
    {'title': 'Burger', 'imageUrl': 'lib/Assets/images/burger.jpeg', 'price': '₱80'},
    {'title': 'Chicken', 'imageUrl': 'lib/Assets/images/Fried_Chicken.jpg', 'price': '₱180'},
    {'title': 'Spaghetti', 'imageUrl': 'lib/Assets/images/Spaghetti.jpg', 'price': '₱150'},
    {'title': 'Drinks', 'imageUrl': 'lib/Assets/images/General_Softdrinks.jpg', 'price': '₱25'},
  ];

  final List<Map<String, String>> popularItems = [
    {
      'title': 'Margherita Pizza',
      'imageUrl': 'lib/Assets/images/Margherita_Pizza.jpeg',
    },
    {
      'title': 'Cheeseburger Deluxe',
      'imageUrl': 'lib/Assets/images/Cheese_Burger.jpg',
    },
    {
      'title': 'Fried Chicken',
      'imageUrl': 'lib/Assets/images/Fried_Chicken.jpg',
    },
    {
      'title': 'Lasagne',
      'imageUrl': 'lib/Assets/images/Lasagne_alla_Bolognese.jpg',
    },
  ];

  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredCategories = [];

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories = categories;
      } else {
        filteredCategories = categories.where((category) {
          return category['title']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 55),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text('Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 58),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
              },
              icon: const Icon(Icons.card_travel_rounded, color: Colors.white),
            ),
          ),
        ],
        toolbarHeight: 120,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                String nickname = 'Guest';
                String avatarUrl = '';

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  nickname = data['name'] ?? 'Guest';
                  avatarUrl = data.containsKey('avatar_url') ? (data['avatar_url'] ?? '') : '';
                }

                if (avatarUrl.isEmpty) {
                  avatarUrl = 'https://api.dicebear.com/9.x/fun-emoji/svg?seed=${Uri.encodeComponent(nickname)}';
                }

                return DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.pinkAccent.shade200, Colors.pinkAccent.shade700],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: avatarUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(nickname,
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(leading: const Icon(Icons.home_outlined, color: Colors.pink), title: const Text('Home'), onTap: () {}),
                  ListTile(leading: const Icon(Icons.shopping_cart_outlined, color: Colors.pink), title: const Text('Orders & reordering'), onTap: () {}),
                  ListTile(
                    leading: const Icon(Icons.person_2_outlined, color: Colors.pink),
                    title: const Text('View Profile'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                    },
                  ),
                  ListTile(leading: const Icon(Icons.location_on_outlined, color: Colors.pink), title: const Text('Addresses'), onTap: () {}),
                  ListTile(leading: const Icon(Icons.payment, color: Colors.pink), title: const Text('Payment Methods'), onTap: () {}),
                  ListTile(leading: const Icon(Icons.help_center_outlined, color: Colors.pink), title: const Text('Help Center'), onTap: () {}),
                  ListTile(leading: const Icon(Icons.settings_outlined, color: Colors.pink), title: const Text('Settings'), onTap: () {}),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.pink),
                    title: const Text('Logout'),
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error signing out. Please try again.'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(leading: const Icon(Icons.info_outline, color: Colors.pink), title: const Text('About Us'), onTap: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Welcome to Lalamon!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            const SizedBox(height: 20),

            // Recommended
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Recommended Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(imageUrl: item['imageUrl']!, height: 100, width: 100, fit: BoxFit.cover),
                        const SizedBox(height: 10),
                        Text(item['title']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(item['price']!, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllCategoriesPage(categories: categories)));
                    },
                    child: const Text('See All', style: TextStyle(color: Colors.pinkAccent)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return CategoryCard(
                    title: category['title']!,
                    imageUrl: category['imageUrl']!,
                    price: category['price']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsPage(categoryTitle: category['title']!),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Popular
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Popular Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularItems.length,
                itemBuilder: (context, index) {
                  final item = popularItems[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(imageUrl: item['imageUrl']!, height: 100, width: 100, fit: BoxFit.cover),
                        const SizedBox(height: 10),
                        Text(item['title']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
