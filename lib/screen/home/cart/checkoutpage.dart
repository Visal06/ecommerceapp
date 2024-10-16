import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatting
import 'package:mycourse_flutter/model/cart_item.dart';

// The main widget class for the CheckoutPage
class CheckoutPage extends StatefulWidget {
  final List<CartItem> items; // List of cart items to display
  final double totalAmounts; // Total amount for the checkout

  const CheckoutPage({
    super.key,
    required this.items,
    required this.totalAmounts,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

// State class for CheckoutPage, where the stateful behavior is implemented
class _CheckoutPageState extends State<CheckoutPage> {
  // Controllers for text fields used for input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // Dispose method is called to release resources when the widget is removed
  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  // The build method describes the UI and the layout of the CheckoutPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with a title and styling
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.green.shade800,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the main body
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns content to the start
          children: [
            // Order Summary heading
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16.0), // Space between elements
            // Expanded widget ensures the list occupies the remaining space
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length, // Number of cart items
                itemBuilder: (context, index) {
                  final item = widget.items[index]; // Current cart item
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                            offset: const Offset(0, 4), // Shadow settings
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded image
                          child: Image.network(
                            item.imageurl, // Image of the cart item
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover, // Ensures image is not stretched
                          ),
                        ),
                        // Display the name and total of each item
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.name, // Name of the product
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Ellipsis if name is too long
                              ),
                            ),
                            // Total price (calculated as price * quantity)
                            Text(
                              'Total: \$${((double.tryParse(item.price) ?? 0.0) * (int.tryParse(item.qty) ?? 0)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        // Display price and quantity
                        subtitle: Text(
                          'Price: \$${item.price} x ${item.qty}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0), // Space between elements
            // Display the grand total of the order
            Text(
              'Grand Total: \$${widget.totalAmounts.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32.0), // Space before the purchase button
            // Button to trigger the payment bottom sheet
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentBottomSheet(
                    context,
                    widget.totalAmounts, // Pass total amount here
                  );
                  // Show bottom sheet for payment
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  'Complete Purchase',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show the payment bottom sheet
  void _showPaymentBottomSheet(
    BuildContext context,
    double totalAmounts,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to be scrollable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        // Bottom sheet with draggable behavior
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (_, controller) => Padding(
            padding: const EdgeInsets.all(
                16.0), // Padding around the bottom sheet content
            child: ListView(
              controller: controller, // Enables scrolling inside the sheet
              children: [
                // Grey bar at the top of the bottom sheet (visual cue)
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Payment Information', // Payment info heading
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 14, 90, 16),
                  ),
                  textAlign: TextAlign.center, // Centered heading
                ),
                const SizedBox(height: 22.0),
                Text(
                  'TOTAL: \$${totalAmounts.toStringAsFixed(2)}', // Display total amount
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.left, // Center the total amount
                ),
                const SizedBox(height: 16.0),
                // Card widget containing payment input fields
                Card(
                  elevation: 4, // Shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align fields to the left
                      children: [
                        const Text(
                          'Card Holder', // Label for cardholder's name
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                            height: 10), // Space between label and text field
                        // Text field for the cardholder's name
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name on Card',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Card Number', // Label for card number
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Text field for the card number with input formatting and icons
                        Stack(
                          children: [
                            TextField(
                              controller: cardNumberController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    16), // Max 16 digits
                                CardNumberInputFormatter(), // Custom formatter
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '1234 5678 9012 3456',
                              ),
                            ),
                            // Visa and MasterCard icons
                            Positioned(
                              right: 50,
                              top: 10,
                              child: SizedBox(
                                width: 30,
                                child: Image.asset(
                                  'assets/image/visa.png', // Visa logo
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: SizedBox(
                                width: 30,
                                child: Image.asset(
                                  'assets/image/master.png', // MasterCard logo
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Row for expiry date and CVV inputs
                        Row(
                          children: [
                            // Expiry date input field
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Expiry Date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: expiryDateController,
                                    keyboardType: TextInputType.datetime,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          4), // Max 4 digits
                                      ExpiryDateInputFormatter(), // Custom formatter
                                    ],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'MM/YY',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // CVV input field
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'CVV',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: cvvController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          3), // Max 3 digits
                                    ],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'CVV',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Button to submit payment
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle payment logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Text(
                              'Make Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom formatter for card number input
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(' ', ''); // Remove spaces
    final buffer = StringBuffer(); // Buffer for formatted text
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]); // Write the next character
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != newText.length) {
        buffer.write(' '); // Add space after every 4 characters
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
          offset: buffer.length), // Update cursor position
    );
  }
}

// Custom formatter for expiry date input
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll('/', ''); // Remove slashes
    final buffer = StringBuffer(); // Buffer for formatted text
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]); // Write the next character
      if (i == 1 && i != newText.length - 1) {
        buffer.write('/'); // Add slash after first 2 characters
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
          offset: buffer.length), // Update cursor position
    );
  }
}
