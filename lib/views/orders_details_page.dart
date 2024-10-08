import 'package:flutter/material.dart';
import 'package:manufacturer/models/order.model.dart';

class OrderDetailPage extends StatelessWidget {
  static const routeID = '/orderDetailsPage';
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Product: ${order.product}',
                style: const TextStyle(fontSize: 16)),
            Text('Price: \$${order.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            Text('Status: ${order.status}',
                style: const TextStyle(fontSize: 16)),
            Text('Order Date: ${order.orderDate.toString()}',
                style: const TextStyle(fontSize: 16)),
            // Add more order details as needed
          ],
        ),
      ),
    );
  }
}
