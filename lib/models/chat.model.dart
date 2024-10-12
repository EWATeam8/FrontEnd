import 'package:manufacturer/models/product.model.dart';

class Chat {
  final String message;
  final DateTime dateTime;
  final bool fromBot;
  final List<Product>? products;
  final List<String>? options;

  Chat({
    required this.message,
    required this.dateTime,
    required this.fromBot,
    this.products,
    this.options,
  });
}
