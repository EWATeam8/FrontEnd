import 'package:manufacturer/logic/order.logic.dart';
import 'package:manufacturer/logic/recommendation.logic.dart';
import 'package:manufacturer/models/order.model.dart';
import 'package:manufacturer/models/product.model.dart';

abstract class ManufacturerServiceInterface {
  // Order related methods
  Future<List<Order>> fetchOrders();
  Future<Order> fetchOrderById(String id);
  Future<void> createOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> deleteOrder(String id);

  // Product recommendation related methods
  Future<List<Product>> fetchRecommendedProducts({int limit = 10});
  Future<Product> fetchProductDetails(String productId);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> fetchProductsByCategory(String category);
}

class ManufacturerService implements ManufacturerServiceInterface {
  final OrderService _orderService;
  final ProductRecommendationService _productService;

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
