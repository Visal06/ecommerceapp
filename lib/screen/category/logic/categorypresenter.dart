import 'dart:convert'; // Import the Dart JSON library for decoding JSON responses.

import 'package:http/http.dart'
    as http; // Import the HTTP package for making network requests.
import 'package:mycourse_flutter/api/api_service.dart'; // Import the ApiService to access API endpoints.
import 'package:mycourse_flutter/model/category.dart'; // Import the Category model to map JSON data to Dart objects.
import 'package:mycourse_flutter/screen/category/logic/catetoryview.dart'; // Import the CategoryView interface for callback methods.

class CategoryPresenter {
  final CategoryView
      view; // Holds a reference to the view that implements the CategoryView interface.

  // Constructor that initializes the view variable.
  CategoryPresenter(this.view);

  // Asynchronous method to fetch categories from the API.
  Future<void> fetchCategories() async {
    view.onLoading(true); // Indicate that data loading has started.
    try {
      // Send a GET request to the specified API endpoint.
      final response = await http.get(
          Uri.parse(ApiService.getAllCategory)); // Update with your endpoint.

      // Check if the response status code is 200 (OK).
      if (response.statusCode == 200) {
        List<dynamic> responseData =
            jsonDecode(response.body); // Decode the JSON response body.
        // Map the list of JSON objects to a list of Categories objects.
        List<Categories> categories =
            responseData.map((json) => Categories.fromJson(json)).toList();
        view.onResponse(
            categories); // Pass the list of categories back to the view.
      } else {
        // If the status code is not 200, trigger an error callback with the status code.
        view.onFetchError("Error fetching categories: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions and pass the error message to the view.
      view.onFetchError(e.toString());
    } finally {
      view.onLoading(
          false); // Indicate that loading has finished, regardless of success or failure.
    }
  }
}
