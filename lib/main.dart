import 'package:flutter/material.dart';
import 'package:manufacturer/routes/routes.dart';
import 'package:manufacturer/theme/theme.dart';
import 'package:manufacturer/views/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoParts App',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ChatPage(),
      onGenerateRoute: (settings) => AppRoutes.generateRoute(settings),
    );
  }
}
