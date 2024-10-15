import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:mycourse_flutter/config/authmanager.dart';
import 'package:mycourse_flutter/model/category.dart';
import 'package:mycourse_flutter/model/product.dart';
import 'package:mycourse_flutter/model/response/appresponseviewmodel.dart';
import 'package:mycourse_flutter/model/slice.dart';
import 'package:mycourse_flutter/screen/home/screen/notification.dart';

class HomePage extends StatefulWidget {
  final AppResponsemodel respo;

  const HomePage({super.key, required this.respo});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _notificationCount = 5;

  @override
  Widget build(BuildContext context) {
    List<Slices> slices = widget.respo.slices;
    List<Categories> categories = widget.respo.categories;
    List<Products> products = widget.respo.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: badges.Badge(
              badgeContent: Text(
                '$_notificationCount',
                style: const TextStyle(color: Colors.white),
              ),
              badgeColor: Colors.red,
              showBadge: _notificationCount > 0,
              position: badges.BadgePosition.topEnd(top: 2, end: 2),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                icon: const Icon(Icons.notifications_none),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ImageSlideshow with automatic sliding
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: ImageSlideshow(
              width: double.infinity,
              height: 200,
              initialPage: 0,
              autoPlayInterval: 3000,
              isLoop: true,
              children: slices.map((slice) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      slice.imageurl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Icon(Icons.error, color: Colors.red));
                      },
                    ),
                  ),
                );
              }).toList(),
              onPageChanged: (value) {
                // Handle page change if needed
              },
            ),
          ),
          // Categories Header and 'more' Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    // Handle the 'more' button tap
                    Navigator.pushNamed(
                      context,
                      "/categories",
                    );
                  },
                  child: const Text(
                    "more..",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Categories ListView
          SizedBox(
            height: 140, // Increase the height to accommodate the title
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                Categories category = categories[index];
                return GestureDetector(
                  onTapDown: (_) {
                    // Optional: Add a scaling effect or tap feedback
                  },
                  onTapUp: (_) {
                    Navigator.pushNamed(
                      context,
                      "/productcategory",
                      arguments: category,
                    );
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [Colors.greenAccent, Colors.green],
                            center: Alignment(-0.6, -0.6),
                            focal: Alignment(-0.3, -0.3),
                            focalRadius: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(-6, -6),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  category.imageurl,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 10,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Category Title below the image
                      Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Products GridView with modern price label
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.77,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Products product = products[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/detailproduct",
                        arguments: product.id,
                      );
                    },
                    child: Stack(
                      children: [
                        // Product Image with rounded borders and shadow
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            product.imageurl,
                            height: 196,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(Icons.error, color: Colors.red));
                            },
                          ),
                        ),

                        // Modern Price Label
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: [Colors.green, Colors.lightGreen],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        // Product Name and Details
                        Positioned(
                          top: 160,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'johndoe@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', () => Navigator.pop(context)),
          _buildDrawerItem(Icons.category, 'Categories',
              () => Navigator.pushNamed(context, '/categories')),
          _buildDrawerItem(Icons.shopping_cart, 'Cart',
              () => Navigator.pushNamed(context, '/cart')),
          _buildDrawerItem(Icons.person, 'Profile',
              () => Navigator.pushNamed(context, '/profile')),
          _buildDrawerItem(Icons.settings, 'Favorites',
              () => Navigator.pushNamed(context, '/favorite')),
          _buildDrawerItem(Icons.logout, 'Logout', () {
            Authmanger.removeToken();

            Navigator.pushReplacementNamed(context, '/sigin');
            // Handle logout
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green), // Set icon color to white
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black), // Optional: Set text color to white
      ),
      onTap: onTap,
    );
  }
}
