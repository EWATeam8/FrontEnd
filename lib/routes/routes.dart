import 'package:flutter/material.dart';
import 'package:manufacturer/views/chat_page.dart';
import 'package:manufacturer/views/orders_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ChatPage.routeID:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      case OrdersPage.routeID:
        return MaterialPageRoute(builder: (_) => const OrdersPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Sorry something went wrong'),
            ),
          ),
        );
    }
  }
}
