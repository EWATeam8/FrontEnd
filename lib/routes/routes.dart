import 'package:flutter/material.dart';
import 'package:manufacturer/views/chat_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ChatPage.routeID:
        return MaterialPageRoute(builder: (_) => const ChatPage());
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
