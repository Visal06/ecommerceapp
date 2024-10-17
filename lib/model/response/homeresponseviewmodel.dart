import 'package:mycourse_flutter/model/category.dart';
import 'package:mycourse_flutter/model/product.dart';
import 'package:mycourse_flutter/model/slice.dart';

class HomeResponsemodel {
  final List<Products> products;
  final List<Categories> categories;
  final List<Slices> slices;

  HomeResponsemodel(
      {required this.slices, required this.products, required this.categories});

  factory HomeResponsemodel.fromJson(Map<String, dynamic> json) {
    // List<Products> pro =
    //     List<Products>.from(json["products"].map((e) => Products.fromJson(e)));
    return HomeResponsemodel(
        slices:
            List<Slices>.from(json["slices"].map((x) => Slices.fromJson(x))),
        // products: List<Products>.from(
        //     json["products"].map((e) => Products.fromJson(e))),
        products: List<Products>.from(
            json["products"].map((e) => Products.fromJson(e))),
        categories: List<Categories>.from(
            json["categories"].map((x) => Categories.fromJson(x)))
        // products:
        //     List<Product>.from(json["product"].map((e) => Product.fromJson(e))),
        // categories: List<Categories>.from(json["category"].map((x) => Categories.fromJson(x))),
        );
  }
}
