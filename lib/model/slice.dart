class Slices {
  final int id;
  final String imageurl;

  Slices({required this.id, required this.imageurl});

  factory Slices.fromJson(Map<String, dynamic> json) {
    return Slices(id: json['id'], imageurl: json['imageurl']);
  }
}
