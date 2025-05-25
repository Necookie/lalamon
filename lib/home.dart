import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lalamon/categories.dart';
import 'package:lalamon/login_page.dart';
import 'package:lalamon/product_details.dart';
import 'package:lalamon/profile_page.dart';
import 'all_categories_page.dart';
import 'cart.dart';
import 'category_details_page.dart';
import 'recommended_items.dart';
import 'payment.dart';
import 'about_us.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> categories = [
    {
      'title': 'Pizza',
      'imageUrl': 'lib/Assets/images/pizza.jpeg',
      'price': '₱150'
    },
    {
      'title': 'Burgers',
      'imageUrl': 'lib/Assets/images/burger.jpeg',
      'price': '₱80'
    },
    {
      'title': 'Meals',
      'imageUrl': 'lib/Assets/images/Fried_Chicken.jpg',
      'price': '₱180'
    },
    {
      'title': 'Beverages',
      'imageUrl': 'lib/Assets/images/General_Softdrinks.jpg',
      'price': '₱25'
    },
  ];

  final List<Map<String, String>> popularItems = [
    {
      'title': 'Margherita Pizza',
      'imageUrl': 'lib/Assets/images/Margherita_Pizza.jpeg'
    },
    {
      'title': 'Cheeseburger Deluxe',
      'imageUrl': 'lib/Assets/images/Cheese_Burger.jpg'
    },
    {
      'title': 'Fried Chicken',
      'imageUrl': 'lib/Assets/images/Fried_Chicken.jpg'
    },
    {
      'title': 'Lasagne',
      'imageUrl': 'lib/Assets/images/Lasagne_alla_Bolognese.jpg'
    },
  ];

  final List<Map<String, String>> recommendedItems = [
    {
      'title': 'Chicago Deep Dish',
      'imageUrl': 'lib/Assets/images/Chicago_Deep_Dish_Pizza.jpg',
      'price': '₱200'
    },
    {
      'title': 'Hellfire Kitchen Burger',
      'imageUrl': 'lib/Assets/images/Hellfire_Chicken_Burger.png',
      'price': '₱150'
    },
    {
      'title': 'BBQ Chicken Wings',
      'imageUrl': 'lib/Assets/images/BBQ_Chicken.jpg',
      'price': '₱180'
    },
    {
      'title': 'Spaghetti Bolognese',
      'imageUrl': 'lib/Assets/images/Spaghetti.jpg',
      'price': '₱120'
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
                const Text('Home',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartPage()));
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
                  avatarUrl = data.containsKey('avatar_url')
                      ? (data['avatar_url'] ?? '')
                      : '';
                }

                if (avatarUrl.isEmpty) {
                  avatarUrl =
                      'https://api.dicebear.com/9.x/fun-emoji/svg?seed=${Uri.encodeComponent(nickname)}';
                }

                return DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.pinkAccent.shade200,
                        Colors.pinkAccent.shade700
                      ],
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
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Welcome back,',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(nickname,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    text: 'Home',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.shopping_cart_outlined,
                    text: 'Orders & Reordering',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_2_outlined,
                    text: 'View Profile',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.location_on_outlined,
                    text: 'Addresses',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.payment,
                    text: 'Payment Methods',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaymentPage()));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_center_outlined,
                    text: 'Help Center',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Error signing out. Please try again.'),
                                backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.pink),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutUsPage()));
                }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  String userName = 'Guest';

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    userName = data['name'] ?? 'Guest';
                  }

                  return Text(
                    'Welcome, $userName',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Categories horizontal list
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsPage(
                            categoryTitle: category['title']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 110,
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.pinkAccent.shade100,
                        image: DecorationImage(
                          image: AssetImage(category['imageUrl']!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3), BlendMode.darken),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category['title']!,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Popular Items',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  // See All button for categories
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCategoriesPage(
                            categories: categories,
                          ),
                        ),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularItems.length,
                itemBuilder: (context, index) {
                  final item = popularItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            productName: item['title']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(item['imageUrl']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Recommended for You',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const RecommendedItems(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent),
      title: Text(text),
      onTap: onTap,
    );
  }
}
