import 'package:flutter/material.dart';
import 'package:manufacturer/views/chat_page.dart';
import 'package:manufacturer/views/cart_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ChatPage.routeID:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      case CartPage.routeID:
        return MaterialPageRoute(builder: (_) => const CartPage());
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
