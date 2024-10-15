class Categories {
  late int id;
  late String title;
  late String imageurl;

  Categories({required this.id, required this.title, required this.imageurl});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        id: json['id'], title: json["title"], imageurl: json['imageurl']);
  }
}
