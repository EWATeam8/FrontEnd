class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String delivery;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.delivery,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'].toDouble(),
        imageUrl: json['imageUrl'],
        delivery: json["delivery"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      "delivery": delivery,
    };
  }
}
