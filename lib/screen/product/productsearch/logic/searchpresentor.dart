import 'dart:convert'; // Import for JSON encoding and decoding

import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:mycourse_flutter/api/api_service.dart'; // Import for API service URLs
import 'package:mycourse_flutter/model/response/productbysearchmodel.dart'; // Import for product model
import 'package:mycourse_flutter/screen/product/productsearch/logic/searchview.dart'; // Import for the view interface

class Productsearchpresentor {
  final ProductSearchview view; // Interface for view to handle responses

  Productsearchpresentor(this.view);

  // Fetches all products for the initial page load
  Future<void> fetchAllProducts() async {
    try {
      view.onLoading(true); // Show loading indicator
      final response = await http.get(Uri.parse(
          ApiService.getAllProducts)); // Make GET request to fetch all products

      if (response.statusCode == 200) {
        // Check if the request was successful
        final List<dynamic> body = jsonDecode(
            response.body); // Decode response body to a list of dynamic

        final List<Productbysearchmodel> data = body
            .map((dynamic item) => Productbysearchmodel.fromjson(item as Map<
                String, dynamic>)) // Convert each item to Productbysearchmodel
            .toList();

        view.onResponse(data); // Pass the data to the view
      } else {
        view.onStringResponse(
            'Failed to load products: ${response.reasonPhrase}'); // Handle error if response is not successful
      }
    } catch (e) {
      view.onStringResponse(
          'An error occurred: ${e.toString()}'); // Handle exception
    } finally {
      view.onLoading(false); // Hide loading indicator
    }
  }

  // Filters products based on the keyword
  Future<void> filterProduct(String keyword,
      {int skip = 0, int take = 100}) async {
    try {
      view.onLoading(true); // Show loading indicator
      final response = await http.post(
        Uri.parse(
            ApiService.filterprodcut), // Make POST request to filter products
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'keyword': keyword, // Pass the search keyword
          'skip': skip, // Pagination skip value
          'take': take, // Pagination take value
        }),
      );

      if (response.statusCode == 200) {
        // Check if the request was successful
        final Map<String, dynamic> json =
            jsonDecode(response.body); // Decode response body to a map

        if (json.containsKey('products')) {
          // Check if the response contains the 'products' key
          final List<dynamic> productsList =
              json['products']; // Get the list of products

          final List<Productbysearchmodel> data = productsList
              .map((dynamic item) => Productbysearchmodel.fromjson(item as Map<
                  String,
                  dynamic>)) // Convert each item to Productbysearchmodel
              .toList();

          view.onResponse(data); // Pass the data to the view
        } else {
          view.onStringResponse(
              'No products found in the response.'); // Handle case where no products are found
        }
      } else {
        view.onStringResponse(
            'Failed to search products: ${response.reasonPhrase}'); // Handle error if response is not successful
      }
    } catch (e) {
      view.onStringResponse(
          'An error occurred: ${e.toString()}'); // Handle exception
    } finally {
      view.onLoading(false); // Hide loading indicator
    }
  }
}
