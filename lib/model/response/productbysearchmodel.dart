import 'package:mycourse_flutter/model/category.dart'; // Import the category model
import 'package:mycourse_flutter/model/productgallary.dart'; // Import the product gallery model

class Productbysearchmodel {
  final int id; // Product ID
  final String category_id; // Category ID of the product
  final String name; // Name of the product
  final String price; // Price of the product
  final String qty; // Quantity of the product
  final int amount; // Amount of the product (numeric value)
  final String totalprice; // Total price (could be for display purposes)
  final String status; // Status of the product (e.g., available, out of stock)
  final String description; // Description of the product
  final String imageurl; // URL of the product image
  final List<Productgallary> gallary; // List of product gallery images
  final Categories? category; // Optional category object

  // Constructor to initialize all fields
  Productbysearchmodel({
    required this.id,
    required this.category_id,
    required this.name,
    required this.price,
    required this.qty,
    required this.amount,
    required this.totalprice,
    required this.status,
    required this.description,
    required this.imageurl,
    required this.gallary,
    required this.category,
  });

  // Factory constructor to create an instance from a JSON map
  factory Productbysearchmodel.fromjson(Map<String, dynamic> json) {
    // Parse the 'product_gallary' field, or default to an empty list if null
    var list = json['product_gallary'] as List? ?? [];
    // Map each item in the list to a Productgallary instance
    List<Productgallary> galleryList =
        list.map((i) => Productgallary.fromJson(i)).toList();

    return Productbysearchmodel(
      id: json['id'] ?? 0, // Default to 0 if 'id' is not present
      category_id: json['category_id'] ??
          '', // Default to empty string if 'category_id' is not present
      name: json['name'] ??
          'Unknown', // Default to 'Unknown' if 'name' is not present
      price:
          json['price'] ?? '0.0', // Default to '0.0' if 'price' is not present
      qty: json['qty'] ?? '0', // Default to '0' if 'qty' is not present
      amount: json['amount'] ?? 0, // Default to 0 if 'amount' is not present
      totalprice: json['totalprice'] ??
          '0.0', // Default to '0.0' if 'totalprice' is not present
      status: json['status'] ??
          'Unknown', // Default to 'Unknown' if 'status' is not present
      description: json['description'] ??
          'No description available', // Default to 'No description available' if 'description' is not present
      imageurl: json['imageurl'] ??
          '', // Default to empty string if 'imageurl' is not present
      gallary: galleryList, // List of gallery images
      category: json['categories'] != null
          ? Categories.fromJson(json[
              'categories']) // Create a Categories instance if 'categories' is present
          : null, // Null if 'categories' is not present
    );
  }
}
