class Onboards {
  final int id;
  late String title;
  late String content;
  final String imageurl;

  Onboards(
      {required this.id,
      required this.title,
      required this.content,
      required this.imageurl});

  factory Onboards.fromJson(Map<String, dynamic> json) {
    return Onboards(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        imageurl: json['imageurl']);
  }
}
