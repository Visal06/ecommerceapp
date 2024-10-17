import 'dart:convert'; // Importing the Dart package for JSON encoding/decoding.

import 'package:badges/badges.dart'
    as badges; // Importing the badges package for displaying badge notifications.
import 'package:flutter/material.dart'; // Importing Flutter's Material Design package.
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; // Importing a package to scan barcodes.
import 'package:mycourse_flutter/model/cart_item.dart';
import 'package:mycourse_flutter/model/response/homeresponseviewmodel.dart'; // Importing a model for the app's response data.
import 'package:mycourse_flutter/screen/cart/screen/cart.dart'; // Importing the CartPage widget.
import 'package:mycourse_flutter/screen/home/logic/homepresentor.dart'; // Importing the presenter class for the home page.
import 'package:mycourse_flutter/screen/home/logic/homeveiw.dart'; // Importing the view interface for the home page.
import 'package:mycourse_flutter/screen/home/screen/home.dart'; // Importing the HomePage widget.
import 'package:mycourse_flutter/screen/home/screen/map.dart'; // Importing the MapScreen widget.
import 'package:mycourse_flutter/screen/product/productsearch/screen/search.dart'; // Importing the SearchPage widget.
//import 'package:mycourse_flutter/screen/product/productdetail/detailproductpage.dart'; // Importing the DetailProductPage widget.
import 'package:shared_preferences/shared_preferences.dart'; // Importing package for storing data locally.

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key}); // Constructor for MasterScreen widget.

  @override
  State<MasterScreen> createState() =>
      _MasterScreenState(); // Creates the state for the MasterScreen.
}

class _MasterScreenState extends State<MasterScreen> implements Homeveiw {
  int _selectedIndex =
      0; // Tracks the currently selected index of the bottom navigation bar.
  late HomeResponsemodel response; // Holds the response model data.
  late bool isLoading; // Indicates whether data is currently loading.
  late String textresponse; // Holds a string response from some API call.
  late HomePresemtor
      presenter; // Instance of the presenter class to manage business logic.
  int cartCount = 0; // Tracks the number of items in the cart.

  @override
  void initState() {
    super.initState(); // Calls the super class's initState method.
    response = HomeResponsemodel(
      slices: [], // Initializes response with empty lists.
      products: [],
      categories: [],
    );
    isLoading = false; // Sets isLoading to false initially.
    textresponse = ''; // Initializes textresponse to an empty string.
    presenter =
        HomePresemtor(this); // Initializes the presenter with this view.
    presenter.getdata(); // Calls the presenter to fetch data.
    loadCartCount(); // Loads the cart count from SharedPreferences.
  }

  // Asynchronously loads the cart count from SharedPreferences.
  Future<void> loadCartCount() async {
    final prefs = await SharedPreferences
        .getInstance(); // Gets the instance of SharedPreferences.
    final String? cartJson =
        prefs.getString("cart_items"); // Retrieves the cart items JSON string.

    if (cartJson != null) {
      final List<dynamic> decodedList =
          json.decode(cartJson); // Decodes the JSON string into a List.
      List<CartItem> items = decodedList
          .map((jsonItem) => CartItem.fromJson(jsonItem))
          .toList(); // Converts each JSON item to CartItem.
      setState(() {
        cartCount = items.length; // Updates cartCount with the number of items.
      });
    }
  }

  // Method to update cart count
  void updateCartCount() {
    loadCartCount(); // Refresh the cart count
  }

  // Handles the item tap event for the bottom navigation bar.
  void _onItemTapped(int index) async {
    if (index == 1) {
      // If the Cart tab is tapped (index 1).
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CartPage(),
        ),
      );
    } else if (index == 4) {
      // If the Scan QR tab is tapped (index 4).
      try {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', // Color of the scan line.
          'Cancel', // Text for the cancel button.
          true, // Whether to show the flash icon.
          ScanMode.BARCODE, // Set the scan mode to barcode.
        );

        if (barcodeScanRes != '-1') {
          // If the scan is not canceled.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Scan result: $barcodeScanRes')), // Displays the scan result.
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error occurred during scanning: $e')), // Displays an error message if an exception occurs.
        );
      }
    } else {
      setState(() {
        _selectedIndex =
            index; // Updates the selected index for the bottom navigation bar.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Shows a loading spinner if isLoading is true.
            : IndexedStack(
                index:
                    _selectedIndex, // Displays the widget corresponding to the selected index.
                children: [
                  HomePage(respo: response), // HomePage widget.
                  const CartPage(), // CartPage widget (placeholder; actual cart data is not passed here).
                  const MapScreen(), // MapScreen widget.
                  const SearchPage(), // SearchPage widget.
                ],
              ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold), // Style for the selected label.
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal), // Style for unselected labels.
            showSelectedLabels: true, // Show selected labels.
            showUnselectedLabels: true, // Show unselected labels.
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the BottomNavigationBar.
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Color of the shadow.
                spreadRadius: 1, // Spread radius of the shadow.
                blurRadius: 5, // Blur radius of the shadow.
                offset: const Offset(0, -1), // Offset of the shadow.
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex:
                _selectedIndex, // Sets the current index of the BottomNavigationBar.
            onTap: _onItemTapped, // Callback for item tap events.
            backgroundColor: Colors
                .transparent, // Background color of the BottomNavigationBar.
            selectedItemColor: Colors.green, // Color for the selected item.
            unselectedItemColor: Colors.grey, // Color for unselected items.
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home), // Icon for the Home tab.
                label: 'Home', // Label for the Home tab.
              ),
              BottomNavigationBarItem(
                icon: badges.Badge(
                  position: badges.BadgePosition.topEnd(
                      top: -10, end: -6), // Position of the badge.
                  badgeContent: Text(
                    '$cartCount', // Displays the number of items in the cart.
                    style: const TextStyle(
                        color: Colors.white), // Style for the badge content.
                  ),
                  showBadge: cartCount >
                      0, // Shows the badge only if cartCount is greater than 0.
                  child:
                      const Icon(Icons.shopping_cart), // Icon for the Cart tab.
                ),
                label: 'Cart', // Label for the Cart tab.
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.location_pin), // Icon for the Locator tab.
                label: 'Locator', // Label for the Locator tab.
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search), // Icon for the Search tab.
                label: 'Search', // Label for the Search tab.
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner), // Icon for the Scan QR tab.
                label: 'Scan QR', // Label for the Scan QR tab.
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onLoading(bool loading) {
    setState(() {
      isLoading = loading; // Updates the loading state.
    });
  }

  @override
  void onResponse(HomeResponsemodel respdata) {
    setState(() {
      response = respdata; // Updates the response data.
    });
  }

  @override
  void onStringResponse(String str) {
    setState(() {
      textresponse = str; // Updates the string response.
    });
  }
}
