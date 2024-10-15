import 'package:flutter/material.dart'; // Import Flutter's material design package
import 'package:mycourse_flutter/model/response/productbysearchmodel.dart'; // Import the model for product data
import 'package:mycourse_flutter/screen/product/productdetail/screen/detialproduct.dart'; // Import the product detail screen
import 'package:mycourse_flutter/screen/product/productsearch/logic/searchpresentor.dart'; // Import the presenter for managing search logic
import 'package:mycourse_flutter/screen/product/productsearch/logic/searchview.dart'; // Import the view interface for search

class SearchPage extends StatefulWidget {
  const SearchPage({super.key}); // Constructor with a key for the widget

  @override
  State<SearchPage> createState() =>
      _SearchPageState(); // Create the state for this widget
}

class _SearchPageState extends State<SearchPage> implements ProductSearchview {
  late Productsearchpresentor
      prosearchpresentor; // Presenter for managing search operations
  List<Productbysearchmodel> probysearch = []; // List to hold all products
  List<Productbysearchmodel> filteredProbysearch =
      []; // List to hold filtered products
  bool isloading = false; // Flag to show loading indicator
  final TextEditingController _searchController =
      TextEditingController(); // Controller for managing search input

  @override
  void initState() {
    super.initState();
    prosearchpresentor =
        Productsearchpresentor(this); // Initialize the presenter with this view
    _fetchAllProducts(); // Fetch all products on initial load

    // Add listener to the search controller to trigger filtering when the text changes
    _searchController.addListener(() {
      _filterProducts(_searchController
          .text); // Filter products based on the current text input
    });
  }

  Future<void> _fetchAllProducts() async {
    await prosearchpresentor.fetchAllProducts(); // Fetch all products initially
  }

  void _filterProducts(String keyword) {
    if (keyword.isEmpty) {
      // When keyword is empty, fetch all products again
      _fetchAllProducts();
    } else {
      prosearchpresentor.filterProduct(
          keyword); // Use the presenter to filter products based on the keyword
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Page', // Title of the AppBar
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // Styling the title text
        ),
        backgroundColor: Colors.green, // AppBar background color
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10), // Margin around the TextField
            child: TextField(
              controller:
                  _searchController, // Assign the controller to manage the input
              decoration: InputDecoration(
                hintText:
                    'Search for products...', // Placeholder text in the TextField
                prefixIcon: const Icon(
                    Icons.search), // Icon to show inside the TextField
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Rounded corners for the border
                  borderSide: BorderSide.none, // No border side
                ),
                filled: true, // Fill the TextField with color
                fillColor:
                    Colors.grey[200], // Background color of the TextField
              ),
            ),
          ),
          isloading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show loading indicator if isloading is true
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredProbysearch
                        .length, // Number of items in the list
                    itemBuilder: (context, index) {
                      final product = filteredProbysearch[
                          index]; // Get the product at the current index
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10), // Margin around the card
                        elevation:
                            5, // Elevation of the card to create a shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for the card
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                              10), // Padding inside the ListTile
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8), // Rounded corners for the image
                            child: Image.network(
                              product.imageurl, // Product image URL
                              width: 80, // Width of the image
                              height: 80, // Height of the image
                              fit: BoxFit
                                  .cover, // Fit the image within the given dimensions
                            ),
                          ),
                          title: Text(
                            product.name, // Product name
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight
                                    .bold), // Styling for the product name
                          ),
                          subtitle: Text(
                            'Price: \$${product.price}\nQty: ${product.qty}', // Product price and quantity
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey), // Styling for the subtitle
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detialproductpage(
                                    id: product
                                        .id), // Navigate to the product detail page
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
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
  void onStringResponse(String str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(str)), // Show error message in a SnackBar
    );
  }

  @override
  void onResponse(List<Productbysearchmodel> response) {
    setState(() {
      probysearch = response; // Update the list of all products
      filteredProbysearch =
          response; // Initialize the filtered list with all products
      isloading = false; // Hide the loading indicator
    });
  }
}
