import 'package:flutter/material.dart';
import 'package:manufacturer/models/cart.model.dart';

class CartPage extends StatefulWidget {
  static const routeID = '/cartPage';

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(id: '1', name: 'Industrial Sewing Machine', price: 999.99),
    CartItem(id: '2', name: 'Overlock Machine', price: 599.99),
    CartItem(id: '3', name: 'Embroidery Machine', price: 1299.99),
  ];

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void _updateQuantity(CartItem item, int change) {
    setState(() {
      item.quantity = (item.quantity + change).clamp(0, 99);
      if (item.quantity == 0) {
        cartItems.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Your Cart'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _updateQuantity(item, -1),
                            ),
                            Text('${item.quantity}',
                                style: const TextStyle(fontSize: 18)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _updateQuantity(item, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Checkout functionality not implemented yet'),
                      ),
                    );
                  },
                  child: const Text('Proceed to Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
