import 'package:flutter/material.dart';
import 'package:manufacturer/models/order.model.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(order.product,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Order ID: ${order.id}\nStatus: ${order.status}'),
        trailing: Text('\$${order.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }
}
