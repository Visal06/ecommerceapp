import 'dart:convert';

import 'package:mycourse_flutter/model/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCard {
  static const String cartKey = 'cart_items';

  Future<bool> saveItem(CartItem newItem) async {
    final List<CartItem> cartItems = await getAllItems();
    final existingItemIndex =
        cartItems.indexWhere((item) => item.productId == newItem.productId);

    if (existingItemIndex != -1) {
      final existingItem = cartItems[existingItemIndex];
      final updatedQty =
          (int.parse(existingItem.qty) + int.parse(newItem.qty)).toString();
      final updatedItem = CartItem(
        productId: existingItem.productId,
        name: existingItem.name,
        qty: updatedQty,
        price: existingItem.price,
        imageurl: existingItem.imageurl,
      );
      cartItems[existingItemIndex] = updatedItem;
    } else {
      cartItems.add(newItem);
    }
    await _saveToPrefs(cartItems);

    return true;
  }

  Future<void> _saveToPrefs(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedItems =
        json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString(cartKey, encodedItems);
  }

  Future<List<CartItem>> getAllItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(cartKey);
    if (cartJson != null) {
      final List<dynamic> decodedList = json.decode(cartJson);
      return decodedList
          .map((jsonItem) => CartItem.fromJson(jsonItem))
          .toList();
    }
    return [];
  }

  // Method to remove an item from the cart by productId
  Future<bool> removeFromCart(String productId) async {
    final List<CartItem> cartItems = await getAllItems();
    cartItems.removeWhere((item) => item.productId == productId);
    await _saveToPrefs(cartItems); // Save the updated list to SharedPreferences
    return true;
  }

  // Method to remove an item from the cart by productId
  Future<bool> removeFromCartall() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("cart_items");
    return true;
  }
}
