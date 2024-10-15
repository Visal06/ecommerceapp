import 'package:mycourse_flutter/model/productgallary.dart';

class Products {
  final int id;
  final String categoryid;
  final String name;
  final String price;
  final String qty;
  final String description;
  final String imageurl;
  final List<Productgallary> gallary;

  Products(
      {required this.id,
      required this.categoryid,
      required this.name,
      required this.price,
      required this.qty,
      required this.description,
      required this.imageurl,
      required this.gallary});

  factory Products.fromJson(Map<String, dynamic> json) {
    var list = json['product_gallary'] as List;
    List<Productgallary> galleryList =
        list.map((i) => Productgallary.fromJson(i)).toList();

    return Products(
        id: json["id"],
        categoryid: json["category_id"],
        name: json['name'],
        price: json['price'],
        qty: json['qty'],
        imageurl: json['imageurl'],
        description: json['description'],
        gallary: galleryList);
  }
}
