import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteProductsPageState createState() => _FavoriteProductsPageState();
}

class _FavoriteProductsPageState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load the favorite products from SharedPreferences.
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorites') ?? [];

    setState(() {
      // Decode the list of favorite products stored in JSON format.
      _favorites = favoriteList
          .map((item) => Map<String, dynamic>.from(jsonDecode(item)))
          .toList();
    });
  }

  // Remove a favorite product and update SharedPreferences.
  Future<void> _removeFavorite(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorites') ?? [];

    // Remove the product from the local favorites list
    favoriteList.removeAt(index);

    // Update the favorites in SharedPreferences
    await prefs.setStringList('favorites', favoriteList);

    // Update the state
    setState(() {
      _favorites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorite Products',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Text('No favorite products yet'),
            )
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                var product = _favorites[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the product detail page when tapped
                    Navigator.pushNamed(
                      context,
                      "/detailproduct",
                      arguments: product['id'],
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: ListTile(
                      leading: Image.network(
                        product['imageurl'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product['name']),
                      subtitle: Text('\$${product['price']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Remove the favorite product
                          _removeFavorite(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
