//import 'package:mycourse_flutter/model/gallary.dart';

import 'package:mycourse_flutter/model/category.dart';
import 'package:mycourse_flutter/model/productgallary.dart';

class ProductBycategorymodel {
  final int id;
  final String category_id;
  final String name;
  final String price;
  final String qty;
  final int amount;
  final String totalprice;
  final String status;
  final String description;
  final String imageurl;
  final List<Productgallary> gallary;
  final Categories? category;

  ProductBycategorymodel(
      {required this.id,
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
      required this.category});

  factory ProductBycategorymodel.fromjson(Map<String, dynamic> json) {
    var list = json['product_gallary'] as List;
    List<Productgallary> galleryList =
        list.map((i) => Productgallary.fromJson(i)).toList();
    return ProductBycategorymodel(
        id: json['id'],
        category_id: json['category_id'],
        name: json['name'],
        price: json['price'],
        qty: json['qty'],
        amount: json['amount'],
        totalprice: json['totalprice'],
        status: json['status'],
        description: json['description'],
        imageurl: json['imageurl'],
        gallary: galleryList,
        category: json['categories'] != null
            ? Categories.fromJson(json['categories'])
            : null);
  }
}
