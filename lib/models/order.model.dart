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
}
