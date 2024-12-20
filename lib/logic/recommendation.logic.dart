import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:manufacturer/models/product.model.dart';

class ProductRecommendationService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://localhost:8080/api';

  Future<List<Product>> fetchRecommendedProducts({int limit = 10}) async {
    try {
      final response = await _dio
          .get('$_baseUrl/send_message', queryParameters: {'limit': limit});
      if (response.statusCode == 200) {
        List<dynamic> productsJson = json.decode(response.data);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Product> fetchProductDetails(String productId) async {
    try {
      final response = await _dio.get('$_baseUrl/products/$productId');
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.data));
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dio
          .get('$_baseUrl/products/search', queryParameters: {'q': query});
      if (response.statusCode == 200) {
        List<dynamic> productsJson = json.decode(response.data);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Exception('Connection timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        return Exception(
            'Server responded with error ${e.response?.statusCode}');
      } else {
        return Exception('An unexpected Dio error occurred: ${e.message}');
      }
    } else {
      return Exception('An unexpected error occurred: $e');
    }
  }
}
