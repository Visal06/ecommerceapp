import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Timer? timer;
  DateTime lastChecked = DateTime.now().subtract(const Duration(minutes: 60));
  List<dynamic> newProducts = [];

  @override
  void initState() {
    super.initState();
    // Poll for new products every 5 minutes
    timer = Timer.periodic(
        const Duration(minutes: 30), (Timer t) => checkForNewProducts());
  }

  Future<void> checkForNewProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/app/product/getnewproducts?last_checked=$lastChecked'),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var products = json.decode(response.body);
        if (products.isNotEmpty) {
          setState(() {
            lastChecked = DateTime.now(); // Update the last checked time
            newProducts = products; // Update the product list with new products
          });
        }
      } else {
        print('Error fetching new products: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to load new products: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: newProducts.isEmpty
          ? const Center(child: Text('No new products'))
          : ListView.builder(
              itemCount: newProducts.length,
              itemBuilder: (context, index) {
                var product = newProducts[index];
                return ListTile(
                  leading: Image.network(
                      product['imageurl']), // Update with correct URL
                  title: Text(product['name']),
                  subtitle: Text('Price: \$${product['price']}'),
                );
              },
            ),
    );
  }
}
