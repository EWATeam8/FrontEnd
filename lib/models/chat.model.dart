import 'package:image_picker/image_picker.dart';
import 'package:manufacturer/models/product.model.dart';

class Chat {
  final String message;
  final DateTime dateTime;
  final bool fromBot;
  final List<String>? options;
  final List<Product>? products;
  final XFile? imageFile; // Add this field

  Chat({
    required this.message,
    required this.dateTime,
    required this.fromBot,
    this.options,
    this.products,
    this.imageFile, // Add this parameter
  });
}
