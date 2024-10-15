import 'package:flutter/material.dart';
import 'package:mycourse_flutter/model/category.dart'; // Import the Category model.
import 'package:mycourse_flutter/screen/category/logic/categorypresenter.dart'; // Import the CategoryPresenter class.
import 'package:mycourse_flutter/screen/category/logic/catetoryview.dart'; // Import the CategoryView interface.

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key}); // Constructor for CategoryScreen.

  @override
  // ignore: library_private_types_in_public_api
  _CategoryScreenState createState() => _CategoryScreenState();
  // Creates the mutable state (_CategoryScreenState) for this widget.
}

class _CategoryScreenState extends State<CategoryScreen>
    implements CategoryView {
  late CategoryPresenter _presenter; // Holds an instance of the presenter.
  bool _isLoading = false; // Tracks whether the app is currently loading data.
  List<Categories> _categories = []; // Stores the fetched list of categories.

  @override
  void initState() {
    super.initState(); // Calls the parent's initState (standard practice).
    _presenter = CategoryPresenter(
        this); // Initializes the presenter with this view (implements CategoryView).
    _presenter
        .fetchCategories(); // Triggers the API request to fetch the categories.
  }

  @override
  void onLoading(bool isLoading) {
    setState(() {
      _isLoading =
          isLoading; // Updates the loading state to show/hide progress indicator.
    });
  }

  @override
  void onResponse(List<Categories> categories) {
    setState(() {
      _categories =
          categories; // Updates the list of categories with the fetched data.
    });
  }

  @override
  void onFetchError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    ); // Displays a SnackBar with an error message if data fetching fails.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ), // Title of the AppBar.
        backgroundColor: Colors.green, // Background color for the AppBar.
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          // If loading is true, display a CircularProgressIndicator at the center of the screen.
          : ListView.builder(
              itemCount: _categories.length,
              // Number of items to display, based on the number of categories fetched.
              itemBuilder: (context, index) {
                final category = _categories[index];
                // Get the current category from the list.
                return CategoryCard(
                  category: category,
                  // Pass the current category to the CategoryCard widget.
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/productcategory",
                      arguments: category,
                    );
                    // Navigate to the /productcategory page, passing the selected category as an argument.
                  },
                );
              },
            ),
      // Builds the list of categories if data is not loading.
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Categories category; // A Categories object representing each category.
  final VoidCallback onTap; // Callback to handle tapping on the category card.

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      // Rounded corners for the Card.
      elevation: 4,
      // Sets the shadow or depth of the Card.
      margin: const EdgeInsets.symmetric(vertical: 8),
      // Vertical margin for spacing between the cards.
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        // Padding inside the ListTile.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          // Rounded corners for the image.
          child: Image.network(
            category.imageurl,
            // Load the image from the URL in the category.
            width: 60,
            // Set the width of the image.
            height: 60,
            // Set the height of the image.
            fit: BoxFit.cover,
            // Ensures the image fits and covers the area proportionally.
          ),
        ),
        title: Text(
          category.title,
          // Display the title of the category.
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          // Sets font size and makes the text bold.
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        // An arrow icon at the end of the ListTile, indicating it's clickable.
        onTap: onTap,
        // Executes the onTap function when the ListTile is tapped.
      ),
    );
  }
}
