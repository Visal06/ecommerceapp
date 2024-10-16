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
            margin: const EdgeInsets.only(top: 8.0),
            child: ImageSlideshow(
              width: double.infinity,
              height: 180, // Adjust height for a smaller image size
              initialPage: 0,
              autoPlayInterval: 3000,
              isLoop: true,

              children: slices.map((slice) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        15), // Slightly reduced border radius
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5), // Lighter border
                      width: 3, // Slightly thinner border
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Lighter shadow
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15), // Consistent border radius
                    child: Stack(
                      children: [
                        // Use a container to ensure proper aspect ratio
                        SizedBox(
                          width: double.infinity,
                          height: 180, // Match the height of the slideshow
                          child: Image.network(
                            slice.imageurl,
                            fit: BoxFit.cover, // Cover to fill the space
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
                        // Overlay with a gradient for a modern look
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
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
                            horizontal: 8.0, vertical: 8.0),
                        width: 65.0,
                        height: 65.0,
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
                          fontSize: 12,
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
          const SizedBox(
            height: 10,
            child: Text('Most Product Features'),
          ),

          // Products GridView with modern price label
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio:
                    0.65, // Adjusted aspect ratio for a more compact look
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Products product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/detailproduct",
                      arguments: product.id,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Stack(
                      children: [
                        // Background with gradient
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal, Colors.lightGreen],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        // Product Image
                        Positioned.fill(
                          child: Image.network(
                            product.imageurl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(Icons.error, color: Colors.red));
                            },
                          ),
                        ),
                        // Price Label
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.monetization_on,
                                    color: Colors.green, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  product.price.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Product Name
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
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
          const SizedBox(height: 28.0),
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
