import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatting
import 'package:mycourse_flutter/config/card.dart';
import 'package:mycourse_flutter/model/cart_item.dart';
import 'package:mycourse_flutter/model/request/paymentrequest.dart';
import 'package:mycourse_flutter/screen/cart/logic/paymentpresentor.dart';
import 'package:mycourse_flutter/screen/cart/logic/paymentview.dart';
import 'package:mycourse_flutter/screen/cart/screen/cartmap.dart';

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
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

// State class for CheckoutPage, where the stateful behavior is implemented
class _CheckoutPageState extends State<CheckoutPage> implements Paymentview {
  // Controllers for text fields used for input
  TextEditingController nameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController txtaddess = TextEditingController();
  TextEditingController txtphone = TextEditingController();

  late AddToCard card;
  late bool isLoading = false;
  late String message = "";
  late Paymentpresentor presenter;
  late bool ispaymentprocess = true;

  bool isPayByDeliveryChecked = false;
  bool isCashByCardChecked = true;
  // Dispose method is called to release resources when the widget is removed
  @override
  void initState() {
    super.initState();
    presenter = Paymentpresentor(this);
    card = AddToCard();
  }

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

// Add a method to open the map
  void _selectLocation() async {
    // Navigate to MapScreen and wait for the result
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    // Update the address text field with the selected location
    if (result != null && result.isNotEmpty) {
      setState(() {
        txtaddess.text = result; // Set the detailed address string
        print(result);
      });
    } else {
      print('No address was returned'); // Debug print
    }
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
      body: isLoading
          ? const CircularProgressIndicator()
          : message != ""
              ? Center(
                  child: Text(message),
                )
              : Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Padding around the main body
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
                          itemCount:
                              widget.items.length, // Number of cart items
                          itemBuilder: (context, index) {
                            final item =
                                widget.items[index]; // Current cart item
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 8.0,
                                      spreadRadius: 2.0,
                                      offset:
                                          const Offset(0, 4), // Shadow settings
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Rounded image
                                    child: Image.network(
                                      item.imageurl, // Image of the cart item
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit
                                          .cover, // Ensures image is not stretched
                                    ),
                                  ),
                                  // Display the name and total of each item
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                      const SizedBox(
                          height: 32.0), // Space before the purchase button
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 16),
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
    // Show a modal bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return ListView(
                  controller: controller,
                  children: [
                    // Draggable indicator
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
                    // Title for the payment information section
                    const Text(
                      'Payment Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 14, 90, 16),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22.0),
                    // Displaying the total amount
                    Text(
                      'TOTAL: \$${totalAmounts.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10.0),
                    // Checkbox for payment by delivery
                    // Checkbox section with checkboxes in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceAround, // Distribute space evenly
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("By Delivery"),
                            value: isPayByDeliveryChecked,
                            onChanged: (value) {
                              setState(() {
                                isPayByDeliveryChecked = value ?? false;
                                isCashByCardChecked =
                                    false; // Uncheck "Pay By Card"
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("By Card"),
                            value: isCashByCardChecked,
                            onChanged: (value) {
                              setState(() {
                                isCashByCardChecked = value ?? false;
                                isPayByDeliveryChecked =
                                    false; // Uncheck "Pay By Delivery"
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    // Card details section shown when "Pay By Card" is selected
                    isCashByCardChecked
                        ? Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Card Holder',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Input for the name on the card
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Name on Card',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Card Number',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Input for the card number with card logos
                                  Stack(
                                    children: [
                                      TextField(
                                        controller: cardNumberController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(16),
                                          CardNumberInputFormatter(),
                                        ],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '1234 5678 9012 3456',
                                        ),
                                      ),
                                      Positioned(
                                        right: 50,
                                        top: 10,
                                        child: SizedBox(
                                          width: 30,
                                          child: Image.asset(
                                            'assets/image/visa.png',
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
                                            'assets/image/master.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Expiry date and CVV input fields
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              keyboardType:
                                                  TextInputType.datetime,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    4),
                                                ExpiryDateInputFormatter(),
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    3),
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
                                ],
                              ),
                            ),
                          )
                        // Address input shown when "Pay By Delivery" is selected
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Address',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: txtaddess,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Your Address',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: txtphone,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Your Phone Number',
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _selectLocation,
                                child: const Text('Select Location on Map'),
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    // Button to make the payment
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle payment logic here
                          onPayment();
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
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Create a placeholder for the Map Selection Screen

  @override
  void onLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void onMessage(String str) {
    setState(() {
      message = str;
      Navigator.pop(context);
      card.removeFromCartall();
    });
  }

  @override
  void onPayment() {
    setState(() {
      var payment = PaymentRequest(
          holdername: nameController.text,
          acc: cardNumberController.text,
          dates: expiryDateController.text,
          cvc: cvvController.text,
          amount: widget.totalAmounts.toString(),
          address: txtaddess.text,
          phone: txtphone.text,
          payby: isPayByDeliveryChecked ? "Pay By Delivery" : "Pay By Card",
          product: widget.items);
      print(jsonEncode(payment));
      presenter.paymentprocess(payment);
    });
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
