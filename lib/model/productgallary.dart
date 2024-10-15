class Productgallary {
  late int id;
  late int productid;
  late String imageurl;

  Productgallary(
      {required this.id, required this.productid, required this.imageurl});

  factory Productgallary.fromJson(Map<String, dynamic> json) {
    return Productgallary(
        id: json["id"],
        productid: json["product_id"],
        imageurl: json["imageurl"]);
  }
}
