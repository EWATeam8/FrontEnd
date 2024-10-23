import 'package:manufacturer/logic/recommendation.logic.dart';
import 'package:manufacturer/models/product.model.dart';

abstract class ManufacturerServiceInterface {
  // Product recommendation methods
  Future<List<Product>> fetchRecommendedProducts({int limit = 10});
  Future<Product> fetchProductDetails(String productId);
  Future<List<Product>> searchProducts(String query);
}

class ManufacturerService implements ManufacturerServiceInterface {
  final ProductRecommendationService _productService;

  static List<Product> products = [];

  ManufacturerService(this._productService);

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
}
