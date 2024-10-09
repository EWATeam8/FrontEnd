import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:manufacturer/models/order.model.dart';

class OrderService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://localhost:5000';

  Future<List<Order>> fetchOrders() async {
    try {
      final response = await _dio.get('$_baseUrl/orders');
      if (response.statusCode == 200) {
        List<dynamic> ordersJson = json.decode(response.data);
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Order> fetchOrderById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/orders/$id');
      if (response.statusCode == 200) {
        return Order.fromJson(json.decode(response.data));
      } else {
        throw Exception('Failed to load order');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/orders',
        data: order.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateOrder(Order order) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/orders/${order.id}',
        data: order.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update order');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/orders/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete order');
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
