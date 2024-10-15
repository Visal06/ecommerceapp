import 'package:flutter/material.dart';
import 'package:mycourse_flutter/config/card.dart';
import 'package:mycourse_flutter/model/cart_item.dart';
import 'package:mycourse_flutter/screen/home/cart/checkoutpage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> items = []; // List to store cart items
  late AddToCard cart; // Instance to manage cart operations

  @override
  void initState() {
    super.initState();
    cart = AddToCard(); // Initialize the cart instance
    getCart(); // Fetch cart items when the widget is initialized
  }

  // Fetch all items in the cart from the data source
  Future<void> getCart() async {
    final itemData = await cart.getAllItems(); // Get all cart items
    setState(() {
      items = itemData.cast<CartItem>(); // Update the list of items
    });
  }

  // Update the quantity of an item in the cart
  void _updateQuantity(CartItem item, int change) {
    setState(() {
      if (change > 0) {
        item.increaseQuantity(); // Increase quantity if change is positive
      } else if (change < 0) {
        item.decreaseQuantity(); // Decrease quantity if change is negative
      }
    });
  }

  // Remove an item from the cart
  Future<void> _removeItem(CartItem item) async {
    await cart.removeFromCart(
        item.productId); // Call the remove function from the cart
    getCart(); // Refresh the cart items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Details'), // AppBar title
        backgroundColor: Colors.green.shade800, // AppBar color
        centerTitle: true, // Center the title
        elevation: 0, // No shadow
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length, // Number of items in the cart
              itemBuilder: (context, index) {
                final product = items[index]; // Get the current item
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color for item
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6.0, // Blur effect for shadow
                          spreadRadius: 1.0, // Spread effect for shadow
                          offset: const Offset(0, 3), // Shadow offset
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align items vertically
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded image
                            child: Image.network(
                              product.imageurl, // Product image URL
                              width: 100, // Image width
                              height: 100, // Image height
                              fit: BoxFit.cover, // Cover the entire area
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Space between image and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Align text to start
                            children: [
                              Text(
                                product.name, // Product name
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87, // Text color
                                ),
                              ),
                              const SizedBox(height: 6), // Space below the name
                              Text(
                                'Price: \$${product.price}', // Product price
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(
                                  height: 4), // Space below the price
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Space between buttons
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green
                                          .shade50, // Background for quantity control
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 40, // Width for remove button
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.remove, // Remove icon
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () => _updateQuantity(
                                                product,
                                                -1), // Decrease quantity
                                          ),
                                        ),
                                        Text(
                                          product.qty, // Current quantity
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40, // Width for add button
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.add, // Add icon
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () => _updateQuantity(
                                                product,
                                                1), // Increase quantity
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete, // Delete icon
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () =>
                                            _removeItem(product), // Remove item
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                8.0), // Padding for total text
                                        child: Text(
                                          'Total: \$${((double.tryParse(product.price) ?? 0.0) * (int.tryParse(product.qty) ?? 1)).toStringAsFixed(2)}', // Total price for the item
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Prevent overflow
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 77), // Space at the bottom
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Navigate to the CheckoutPage when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(
                items: items, // Pass items to the CheckoutPage
                totalAmounts: _calculateTotal(), // Calculate total amount
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade800, // Button color
          padding: const EdgeInsets.symmetric(
              horizontal: 50, vertical: 14), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded button
          ),
        ),
        child: const Text(
          'Checkout', // Button text
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Center the button
      bottomNavigationBar: Container(
        height: 70.0, // Height of the bottom bar
        color: Colors.green.shade800, // Background color
        padding: const EdgeInsets.symmetric(
            horizontal: 14.0, vertical: 8.0), // Padding
        child: Center(
          child: Text(
            'Your total: \$${_calculateTotal()}', // Display total price
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  // Calculate the total price of all items in the cart
  double _calculateTotal() {
    return items.fold(0.0, (sum, item) {
      final price = double.tryParse(item.price) ?? 0.0; // Get item price
      final qty = int.tryParse(item.qty) ?? 0; // Get item quantity
      return sum + (price * qty); // Sum total price
    });
  }
}
