class CartItem {
  late String productId;
  late String name;
  late String imageurl;
  late String price;
  late String qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.imageurl,
    required this.price,
    required this.qty,
  });

  // Method to increase the quantity
  void increaseQuantity() {
    int currentQty = int.tryParse(qty) ?? 0;
    currentQty += 1;
    qty = currentQty.toString();
  }

  // Method to decrease the quantity
  void decreaseQuantity() {
    int currentQty = int.tryParse(qty) ?? 0;
    if (currentQty > 1) {
      currentQty -= 1;
    }
    qty = currentQty.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": productId,
      "name": name,
      "imageurl": imageurl,
      "price": price,
      "qty": qty,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json["id"],
      name: json["name"],
      imageurl: json["imageurl"],
      price: json["price"],
      qty: json["qty"],
    );
  }
}
