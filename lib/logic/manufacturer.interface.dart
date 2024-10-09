import 'package:manufacturer/logic/order.logic.dart';
import 'package:manufacturer/logic/recommendation.logic.dart';
import 'package:manufacturer/models/order.model.dart';
import 'package:manufacturer/models/product.model.dart';

abstract class ManufacturerServiceInterface {
  // Order methods
  Future<List<Order>> fetchOrders();
  Future<Order> fetchOrderById(String id);
  Future<void> createOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> deleteOrder(String id);

  // Product recommendation methods
  Future<List<Product>> fetchRecommendedProducts({int limit = 10});
  Future<Product> fetchProductDetails(String productId);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> fetchProductsByCategory(String category);
}

class ManufacturerService implements ManufacturerServiceInterface {
  final OrderService _orderService;
  final ProductRecommendationService _productService;

  static List<Product> products = [
    Product(
      id: '1',
      name: 'Heavy-duty Industrial Sewing Machine',
      description:
          'This heavy-duty industrial sewing machine is perfect for high-volume production. It features a powerful motor and multiple stitching options.',
      imageUrl: 'https://example.com/sewing-machine.jpg',
      category: 'Manufacturer',
      price: 100,
    ),
    Product(
      id: '2',
      name: 'Overlock Machine',
      description:
          'An overlock machine that provides professional finishes for garments, with multiple thread options for a clean look.',
      imageUrl: 'https://example.com/overlock-machine.jpg',
      category: 'Manufacturer',
      price: 100,
    ),
    Product(
      id: '3',
      name: 'Embroidery Machine',
      description:
          'Designed for easy use, this embroidery machine delivers intricate designs on your fabric with precision.',
      imageUrl: 'https://example.com/embroidery-machine.jpg',
      category: 'Manufacturer',
      price: 100,
    ),
  ];

  ManufacturerService(this._orderService, this._productService);

  // Order related methods
  @override
  Future<List<Order>> fetchOrders() => _orderService.fetchOrders();

  @override
  Future<Order> fetchOrderById(String id) => _orderService.fetchOrderById(id);

  @override
  Future<void> createOrder(Order order) => _orderService.createOrder(order);

  @override
  Future<void> updateOrder(Order order) => _orderService.updateOrder(order);

  @override
  Future<void> deleteOrder(String id) => _orderService.deleteOrder(id);

  // Product recommendation related methods
  @override
  Future<List<Product>> fetchRecommendedProducts({int limit = 10}) =>
      _productService.fetchRecommendedProducts(limit: limit);

  @override
  Future<Product> fetchProductDetails(String productId) =>
      _productService.fetchProductDetails(productId);

  @override
  Future<List<Product>> searchProducts(String query) =>
      _productService.searchProducts(query);

  @override
  Future<List<Product>> fetchProductsByCategory(String category) =>
      _productService.fetchProductsByCategory(category);
}
