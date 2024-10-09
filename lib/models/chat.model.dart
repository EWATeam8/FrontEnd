import 'package:manufacturer/models/product.model.dart';

class Chat {
  final String message;
  final DateTime dateTime;
  final bool fromBot;
  final Product? product; // Add this to include product recommendations

  Chat({
    required this.message,
    required this.dateTime,
    required this.fromBot,
    this.product,
  });
}
