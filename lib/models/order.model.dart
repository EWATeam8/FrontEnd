class Order {
  final String id;
  final String product;
  final double price;
  final String status;
  final DateTime orderDate;
  final int quantity;
  final String color;
  final String size;

  Order({
    required this.id,
    required this.product,
    required this.price,
    required this.status,
    required this.orderDate,
    required this.quantity,
    required this.color,
    required this.size,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      product: json['product'],
      price: json['price'].toDouble(),
      status: json['status'],
      orderDate: DateTime.parse(json['orderDate']),
      quantity: json['quantity'],
      color: json['color'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'price': price,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'quantity': quantity,
      'color': color,
      'size': size,
    };
  }
}
