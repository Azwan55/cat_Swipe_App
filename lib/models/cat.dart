class Cat {
  final int id;
  final String imageUrl;

  Cat({required this.id, required this.imageUrl});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      imageUrl: json['imageUrl'],
    );
  }
}
