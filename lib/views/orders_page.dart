import 'package:flutter/material.dart';
import 'package:manufacturer/models/order.model.dart';
import 'package:manufacturer/views/orders_details_page.dart';
import 'package:manufacturer/widgets/order_card.widget.dart';

class OrdersPage extends StatefulWidget {
  static const routeID = '/ordersPage';
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    orders = [
      Order(
        id: '6',
        product: 'Heavy-duty Industrial Sewing Machine',
        price: 1999.99,
        status: 'Processing',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        quantity: 10,
        color: 'N/A',
        size: 'N/A',
      ),
      Order(
        id: '7',
        product: 'Overlock Machine (Sergers)',
        price: 1299.99,
        status: 'Shipped',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        quantity: 15,
        color: 'N/A',
        size: 'N/A',
      ),
      Order(
        id: '8',
        product: 'Embroidery Machine',
        price: 5999.99,
        status: 'Completed',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        quantity: 5,
        color: 'N/A',
        size: 'N/A',
      ),
      Order(
        id: '9',
        product: 'Seam Sealing Machine',
        price: 2999.99,
        status: 'Processing',
        orderDate: DateTime.now(),
        quantity: 8,
        color: 'N/A',
        size: 'N/A',
      ),
      Order(
        id: '10',
        product: 'Buttonhole Machine',
        price: 3500.00,
        status: 'Cancelled',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        quantity: 6,
        color: 'N/A',
        size: 'N/A',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(
              order: orders[index],
              onTap: () => _navigateToOrderDetails(orders[index]));
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Sort by Product Name'),
              onTap: () {
                setState(() {
                  orders.sort((a, b) => a.product.compareTo(b.product));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Sort by Price'),
              onTap: () {
                setState(() {
                  orders.sort((a, b) => a.price.compareTo(b.price));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Sort by Order Date'),
              onTap: () {
                setState(() {
                  orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailPage(order: order)),
    );
  }
}
