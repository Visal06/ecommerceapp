import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mycourse_flutter/config/card.dart';
import 'package:mycourse_flutter/model/cart_item.dart';
import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';
import 'package:mycourse_flutter/screen/product/productdetail/logic/productdetailpresentor.dart';
import 'package:mycourse_flutter/screen/product/productdetail/logic/productdetailview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detialproductpage extends StatefulWidget {
  final int id; // ID of the product being viewed
  const Detialproductpage({super.key, required this.id});

  @override
  State<Detialproductpage> createState() => _DetialproductpageState();
}

class _DetialproductpageState extends State<Detialproductpage>
    implements Productdetailview {
  bool isloading = true; // Track loading state
  late ProductBycategorymodel? product; // Product data
  late Productdetailpresentor presentor; // Presenter to handle logic
  late AddToCard addToCard; // Cart handler class
  String string = ''; // Placeholder for additional string response
  int _quantity = 1; // Initial product quantity
  final PageController _galleryPageController =
      PageController(); // Controller for product gallery
  int _currentGalleryPage = 0; // Track current gallery page index

  // State to manage favorite status
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    presentor = Productdetailpresentor(this); // Initialize presenter
    presentor.getProDetail(widget.id.toString()); // Fetch product details by ID

    // Load the favorite status when the page is initialized
    _loadFavoriteStatus();

    _galleryPageController.addListener(() {
      if (_galleryPageController.hasClients) {
        setState(() {
          _currentGalleryPage = _galleryPageController.page?.toInt() ??
              0; // Update current page index in gallery
        });
      }
    });
    addToCard = AddToCard(); // Initialize cart handler
  }

  // Load favorite status from SharedPreferences
  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorites') ?? [];

    // Check if the current product ID is in the favorite list
    setState(() {
      _isFavorited = favoriteList.any((item) {
        var prod = jsonDecode(item);
        return prod['id'] ==
            widget.id; // Check if the current product ID matches
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Product Details'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pop(context), // Go back to the previous screen
        ),
      ),
      body: isloading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : product == null
              ? const Center(
                  child: Text(
                      'No product details available')) // Show message if no product is found
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 6),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                // Main product image with shadow and rounded corners
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(product!
                                          .imageurl), // Load product image from URL
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Favorite icon overlay on top right
                                IconButton(
                                  icon: Icon(
                                    _isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        _isFavorited ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: _toggleFavorite,
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Product details and action buttons
                            Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Product name
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        product!.name, // Display product name
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Product price
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '\$${product!.price}', // Display product price
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Display product description using HTML widget
                                    HtmlWidget(product!.description),
                                    const SizedBox(height: 16),
                                    // Quantity selector and amount display
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            const Text(
                                              'Amount: ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.blueGrey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '$_quantity', // Display current quantity
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Quantity control buttons
                                        Row(
                                          children: <Widget>[
                                            _buildQuantityButton(
                                              icon: Icons
                                                  .remove, // Decrement button
                                              color: Colors.redAccent,
                                              onPressed:
                                                  _decrementQuantity, // Reduce quantity
                                            ),
                                            const SizedBox(width: 10),
                                            _buildQuantityButton(
                                              icon:
                                                  Icons.add, // Increment button
                                              color: Colors.teal,
                                              onPressed:
                                                  _incrementQuantity, // Increase quantity
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Add to cart button
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.green,
                                            Colors.teal
                                          ], // Gradient for button background
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white),
                                        label: const Text(
                                          'Add to Cart',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .transparent, // Button inherits container style
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          var carts = CartItem(
                                              // Create cart item
                                              productId: product!.id.toString(),
                                              name: product!.name.toString(),
                                              imageurl: product!.imageurl,
                                              price: product!.price.toString(),
                                              qty: _quantity.toString());
                                          addToCard.saveItem(
                                              carts); // Save item to cart
                                          // Show success dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Success'),
                                                content: const Text(
                                                    'Item added to cart successfully!'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close dialog
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          setState(() {
                                            _quantity =
                                                1; // Reset quantity after adding to cart
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Product image gallery
                            SizedBox(
                              height: 140,
                              child: PageView.builder(
                                controller:
                                    _galleryPageController, // Control gallery page scrolling
                                itemCount: product!
                                    .gallary.length, // Number of gallery images
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(product!
                                            .gallary[index]
                                            .imageurl), // Load gallery image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Page indicator for gallery
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List<Widget>.generate(
                                product!.gallary.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: _currentGalleryPage == index
                                      ? 12
                                      : 8, // Dynamic indicator size
                                  height: 8,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentGalleryPage == index
                                        ? Colors.green
                                        : Colors.grey.withOpacity(
                                            0.5), // Active/inactive indicator color
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Method to toggle favorite status
  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorites') ?? [];

    if (_isFavorited) {
      // Remove from favorites
      favoriteList.removeWhere((item) {
        var prod = jsonDecode(item);
        return prod['id'] == widget.id; // Match current product ID
      });
      _isFavorited = false; // Update state
    } else {
      // Add to favorites
      var newFavorite = jsonEncode({
        'id': widget.id,
        'name': product!.name,
        'imageurl': product!.imageurl,
        'price': product!.price,
      });
      favoriteList.add(newFavorite); // Add product to favorites
      _isFavorited = true; // Update state
    }

    await prefs.setStringList(
        'favorites', favoriteList); // Save updated favorites
    setState(() {}); // Trigger UI update
  }

  // Decrement quantity with bounds checking
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  // Increment quantity with bounds checking
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Build button for quantity controls
  Widget _buildQuantityButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  @override
  void onLoading(bool loading) {
    setState(() {
      isloading = loading; // Update loading state
    });
  }

  @override
  void onResponse(ProductBycategorymodel response) {
    setState(() {
      product = response; // Update product details
      isloading = false; // Stop loading
    });
  }

  @override
  void onStringResponse(String str) {
    setState(() {
      string = str; // Update additional string response
    });
  }
}
